module Crawling
  module Crawler
    extend self

    def execute(script)
      @logger = Logging::Logger.new(severity: script.log_level)
      @extraction = Extraction.create(script: script)
      @fields = script.project.data_fields
      @logger.debug('Extraction created', @extraction)
      begin
        try_execute(script)
        #reset retries after successful extraction
        script.retries_left = script.retries
        script.save
      rescue Exception => e
        @logger.error(e.to_s, @extraction)
        e.backtrace.each do |msg|
          break unless msg.include?('WebX')
          @logger.error(msg, @extraction)
        end
        @extraction.success = false
        @extraction.save!
        if script.retries_left > 0
          #ENQUEUE
          Resque.enqueue(CrawlerExecuter, script.id)
          @logger.debug("Re-trying extraction", @extraction)
          script.retries_left -= 1
          script.save
        end
      end
    end

    def try_execute(script)
      @agent = Mechanize.new
      @agent.user_agent_alias = 'Mac Safari'
      @agent.verify_mode = OpenSSL::SSL::VERIFY_NONE
      @post = Postprocessing.new
      @break = false

      script_json = script.xpaths
      @parent_stack = []

      # exit when opening URL fails
      doc = try_get_url(@extraction, script_json['url'])
      return if doc.nil?

      instance = Instance.create(extraction_id: @extraction.id)
      instance.parent_id = instance.id
      instance.save!

      data_row = script_json['data']
      iterate_json(data_row, doc, instance, script_json['url'], 'url')

      script.last_run = Time.now
      script.save!
      @extraction.execution_time = Time.now - @extraction.created_at
      @extraction.success = true
      @extraction.save!
      @logger.debug("Execution time: #{@extraction.execution_time}", @extraction)

      if script_json['uniq']
        duplicates = @post.remove_duplicates(@extraction, script_json['uniq'], script_json['substring'])
        @logger.debug("Duplicate rows removed: #{duplicates}", @extraction)
      end
    end

    def iterate_json(data_row, page, instance, parent_url, field_name, page_number=0)
      sleep(rand(1..5))

      login_row = @post.login_row(data_row)
      page, parent_url = log_in(page, login_row) unless login_row.nil?

      ExtractionDatum.create(
          instance_id: instance.id, extraction_id: @extraction.id,
          field_name: field_name, value: @post.type_check(parent_url, 'link', page)
      ) unless parent_url.nil?

      instance.is_leaf = true

      data_row.each do |row|
        extracted_data = create_extraction_data(instance, page, row)

        if @post.is_postprocessing(row, 'filter') and is_date(row)
          @logger.debug("Filtering date #{extracted_data.value}", @extraction)
          if @post.filter(row, extracted_data.value.to_date, false)
            @logger.debug("Breaking - date: #{extracted_data.value}", @extraction)
            instance.destroy
            @break = true
            break
          end
          if @post.filter(row, extracted_data.value.to_date, true)
            @logger.debug("Skipping - date: #{extracted_data.value}", @extraction)
            instance.destroy
            break
          end
        end

        if @post.is_postprocessing(row, 'nested')
          instance.is_leaf = false
          product_urls = []
          product_urls = @post.extract_attribute(page, row['xpath'], 'href')
          @parent_stack.push(instance.id)

          @logger.debug("Nested links: #{product_urls.size}", @extraction)

          product_urls.each do |url|
            nested_page = try_get_url(@extraction, url)
            next if nested_page.nil?

            new_instance = Instance.create(extraction_id: @extraction.id, parent_id: @parent_stack[-1])
            nested_row = @post.postprocessing_data(row, 'nested', 'data')

            iterate_json(nested_row, nested_page, new_instance, url, row['name']) unless @break
          end

          @parent_stack.pop

        elsif @post.is_postprocessing(row, 'restrict')
          instance.is_leaf = false
          partial_htmls = []
          partial_htmls = page.parser.xpath(row['xpath'])
          @parent_stack.push(instance.id)

          @logger.debug("Restrict htmls: #{partial_htmls.size}", @extraction)

          partial_htmls.each do |html|
            restricted_page = mechanize_page(html, page.uri)
            new_instance = Instance.create(extraction_id: @extraction.id, parent_id: @parent_stack[-1])
            nested_row = @post.postprocessing_data(row, 'restrict', 'data')
            iterate_json(nested_row, restricted_page, new_instance, nil, row['name']) unless @break
          end

          @parent_stack.pop
        end
        
      end
      instance.save!

      # NEXT PAGE
      return unless next_page?(data_row, page_number)
      next_page_xpath = @post.pagination(data_row, 'xpath')

      unless next_page_xpath.nil?
        next_url = page.parser.xpath(next_page_xpath)
        @logger.debug("Next page url: #{next_url}", @extraction)
        next_page = try_get_url(@extraction, next_url)
        return if next_page.nil?

        iterate_json(data_row, next_page, instance, next_url, 'url', page_number+1) unless @break
      end

    end

    def next_page?(data_row, page_number)
      @post.is_pagination(data_row) and @post.pagination(data_row, 'limit') > page_number
    end

    def create_extraction_data(instance, page, row)
      # don't save restricted parent element or pagination element
      return if @post.is_postprocessing(row, 'restrict') or @post.is_pagination(row) or @post.is_postprocessing(row, 'post')
      extraction_datum = ExtractionDatum.create(
        instance_id: instance.id, extraction_id: @extraction.id,
        field_name:  row['name'], value: extract_value(page, row)
      )
      @logger.debug(log_msg(extraction_datum, row), @extraction)
      extraction_datum
    end

    def mechanize_page(html, uri)
      page = Mechanize::Page.new(uri, { 'content-type' => 'text/html' }, html.to_s, nil, @agent)
      page.encoding = "utf-8"
      page
    end

    def log_msg(extraction_datum, nested_row)
      "field: #{nested_row['name']}, xpath: #{nested_row['xpath']}, value: #{extraction_datum.value}"
    end

    def try_get_url(extraction, url)
      begin
        nested_page = @agent.get(url)
      rescue Exception => e
        @logger.error("#{e.to_s} url: #{url}", extraction)
        extraction.success = false
        extraction.save!
        nested_page = nil
      end
      nested_page
    end

    def log_in(page, row)
      #TODO doplnit logy ak sa nepodari najst formular atd
      form_node = page.at(row['xpath'])
      form = page.form(form_node: form_node)
      if form.nil?
        @logger.warning("Form not found at xpath: #{row['xpath']}", @extraction)
        return page, nil
      end

      @post.postprocessing_data(row, 'post','fields').each do |field_row|
        next if field_row['disabled'] == true or field_row['value'].empty?

        form.field_with(name: field_row['name']).value = field_row['value']

        @logger.debug("Filling in field #{field_row['name']}", @extraction)
      end
      form.submit
      @logger.debug("Submitted", @extraction)

      #vrati novu page a URL
      redirect_url = @post.postprocessing_data(row, 'post', 'redirect_url')
      return try_get_url(nil, redirect_url), redirect_url
    end

    def extract_value(doc, row)
      #TODO: refactor postprocessing
      type = nil
      @fields.each do |f|
        if f.name.eql?(row['name'])
          type = f.data_type
          break
        end
      end

      value = nil
      value = @post.extract_attribute(doc, row['xpath'], 'href') if @post.is_postprocessing(row, 'nested')
      value = @post.extract_attribute(doc, row['xpath'], @post.attribute(row)) if @post.is_postprocessing(row, 'attribute')
      value = @post.type_check(value, type, doc) if type.eql?("link")

      return value unless value == nil
      begin
        value = @post.extract_text(doc, type, row['xpath'])
      rescue Exception => e
        @logger.warning(e.to_s + ": #{row['xpath']}", @extraction)
        value = ""
      end
      return value.to_s.strip if @post.is_postprocessing(row, 'trim')
      return value.to_s.gsub(/\s+/, '') if @post.is_postprocessing(row, 'whitespace')
      value.to_s.strip
    end

    def is_date row
      DataField.find_by(name: row['name'], project_id: @extraction.script.project_id).data_type.eql?('date')
    end

  end
end
