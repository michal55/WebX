module Crawling
  module Crawler
    extend self

    def execute(script)
      @logger = Logging::Logger.new(severity: script.log_level)
      @extraction = Extraction.create(script: script)
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
      @logger.warning(data_row.to_s, @extraction)
      iterate_json(data_row, doc, instance, script_json['url'], 'url')

      script.last_run = Time.now
      script.save!
      @extraction.execution_time = Time.now - @extraction.created_at
      @extraction.success = true
      @extraction.save!
      @logger.debug("Execution time: #{@extraction.execution_time}", @extraction)
    end

    def iterate_json(data_row, page, instance, parent_url, field_name)
      sleep(rand(1..5))

      ExtractionDatum.create(
          instance_id: instance.id, extraction_id: @extraction.id,
          field_name: field_name, value: parent_url
      ) unless parent_url.nil?

      instance.is_leaf = true

      data_row.each do |row|
        create_extraction_data(instance, page, row)

        if @post.is_nested(row['postprocessing'])
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

        elsif @post.is_restrict(row['postprocessing'])
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
      return if @post.pagination(data_row, 'limit') == 0
      next_page_xpath = @post.pagination(data_row, 'xpath')
      data_row = @post.decr_page_limit(data_row)

      unless next_page_xpath.nil?
        next_url = page.parser.xpath(next_page_xpath)
        next_page = try_get_url(next_url, @extraction)
        return if next_page.nil?

        iterate_json(data_row, next_page, instance, next_url, field_name)
      end

    end

    def create_extraction_data(instance, page, row)
      # don't save restricted parent element
      return if @post.is_restrict(row['postprocessing'])

      extraction_datum = ExtractionDatum.create(
        instance_id: instance.id, extraction_id: @extraction.id,
        field_name:  row['name'], value: extract_value(page, row)
      )
      @logger.debug(log_msg(extraction_datum, row), @extraction)
    end

    def mechanize_page(html)
      Mechanize::Page.new(nil, { 'content-type' => 'text/html' }, html.to_s, nil, @agent)
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
      return @post.extract_attribute(doc, row['xpath'], 'href') if @post.is_nested(row['postprocessing'])
      return @post.extract_attribute(doc, row['xpath'], row['postprocessing'][0]['attribute']) if @post.attributes?(row['postprocessing'])
      value = @post.extract_text(doc, row['xpath'])
      return value.to_s.strip if @post.is_trim(row['postprocessing'])
      return value.to_s.gsub(/\s+/, '') if @post.is_whitespace(row['postprocessing'])
      value.to_s.strip
    end

    def try_html
      @agent = Mechanize.new
      url = "http://www.byty.sk/3-izbove-byty"
      page = @agent.get(url)
      # xpath = "//*[@id=\"nastranu\"]/ul/li[2]/following-sibling::li[1]/a"
      # xpath = "//li[@class=\"active\"]"
      # xpath = "/html/head/link[@rel=\"next\"]"
      xpath = "//*[@rel=\"next\"]"
      puts page.parser.xpath(xpath)

    end
  end
end
