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
      rescue Exception => e
        @logger.error(e.to_s, @extraction)
        @extraction.success = false
        @extraction.save!
        puts e.to_s
      end
    end

    def try_execute(script)
      @agent = Mechanize.new
      @post = Postprocessing.new
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
    end

    def iterate_json(data_row, page, instance, parent_url, field_name, page_number=0)
      sleep(rand(1..5))

      ExtractionDatum.create(
          instance_id: instance.id, extraction_id: @extraction.id,
          field_name: field_name, value: parent_url
      ) unless parent_url.nil?

      instance.is_leaf = true

      data_row.each do |row|
        create_extraction_data(instance, page, row)

        if @post.is_postprocessing(row, 'nested')
          instance.is_leaf = false
          product_urls = @post.extract_attribute(page, row['xpath'], 'href')
          @parent_stack.push(instance.id)

          @logger.debug("Nested links: #{product_urls.size}", @extraction)

          product_urls.each do |url|
            nested_page = try_get_url(@extraction, url)
            next if nested_page.nil?

            new_instance = Instance.create(extraction_id: @extraction.id, parent_id: @parent_stack[-1])
            nested_row = row['postprocessing'][0]['data']

            iterate_json(nested_row, nested_page, new_instance, url, row['name'])
          end

          @parent_stack.pop

        elsif @post.is_postprocessing(row, 'restrict')
          instance.is_leaf = false
          partial_htmls = page.parser.xpath(row['xpath'])
          @parent_stack.push(instance.id)

          @logger.debug("Restrict htmls: #{partial_htmls.size}", @extraction)

          partial_htmls.each do |html|
            restricted_page = mechanize_page(html)
            new_instance = Instance.create(extraction_id: @extraction.id, parent_id: @parent_stack[-1])
            nested_row = row['postprocessing'][0]['data']
            iterate_json(nested_row, restricted_page, new_instance, nil, row['name'])
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
        next_page = try_get_url(@extraction, next_url)
        return if next_page.nil?

        iterate_json(data_row, next_page, instance, next_url, 'url', page_number+1)
      end

    end

    def next_page?(data_row, page_number)
      @post.is_pagination(data_row) and @post.pagination(data_row, 'limit') > page_number
    end

    def create_extraction_data(instance, page, row)
      # don't save restricted parent element or pagination element
      return if @post.is_postprocessing(row, 'restrict') or @post.is_pagination(row)

      extraction_datum = ExtractionDatum.create(
        instance_id: instance.id, extraction_id: @extraction.id,
        field_name:  row['name'], value: extract_value(page, row)
      )
      @logger.debug(log_msg(extraction_datum, row), @extraction)
    end

    def mechanize_page(html)
      page = Mechanize::Page.new(nil, { 'content-type' => 'text/html' }, html.to_s, nil, @agent)
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

    def extract_value(doc, row)
      #TODO: refactor postprocessing
      type = nil
      @fields.each do |f|
        if f.name.to_s.eql?(row['name'])
          type = f.data_type
          break
        end
      end

      value = nil
      value = @post.extract_attribute(doc, row['xpath'], 'href') if @post.is_postprocessing(row, 'nested')
      value = @post.extract_attribute(doc, row['xpath'], @post.attribute(row)) if @post.is_postprocessing(row, 'attribute')
      if type.to_s.eql?('link')
        value = @post.type_check(value, type, doc)
      end

      return value unless value == nil
      value = @post.extract_text(doc, type,row['xpath'])
      return value.to_s.strip if @post.is_postprocessing(row, 'trim')
      return value.to_s.gsub(/\s+/, '') if @post.is_postprocessing(row, 'whitespace')
      value.to_s.strip
    end

  end
end
