module Crawling
  module Crawler
    extend self

    def execute(script)
      @logger = Logging::Logger.new(severity: script.log_level)
      begin
        try_execute(script)
      rescue Exception => e
        @logger.error("#{e.to_s} url: #{url}", extraction)
      end
    end

    def try_execute(script)
      @agent = Mechanize.new
      @post = Postprocessing.new
      script_json = script.xpaths
      @extraction = Extraction.create(script: script)
      @parent_stack = []
      @logger.debug('Extraction created', @extraction)

      # exit when opening URL fails
      doc = try_get_url(@extraction, script_json['url'])
      return if doc.nil?


      instance = Instance.create(extraction_id: @extraction.id)
      instance.parent_id = instance.id
      instance.save
      data_row = script_json['data']

      iterate_json(data_row, doc, instance)

      script.last_run = Time.now
      script.save!
      @extraction.execution_time = script.last_run - @extraction.created_at
      @extraction.success = true
      @extraction.save!
      @logger.debug("Execution time: #{@extraction.execution_time}", @extraction)
    end

    def iterate_json(data_row, page, instance)
      data_row.each do |row|
        extraction_datum = ExtractionDatum.create(
            instance_id: instance.id, extraction_id: @extraction.id,
            field_name:  row['name'], value: extract_value(page, row)
        )
        @logger.debug(log_msg(extraction_datum, row), @extraction)

        if @post.is_nested(row['postprocessing'])
          product_urls = @post.extract_href(page, row['xpath'])
          @parent_stack.push(instance.id)

          @logger.debug("Nested links: #{product_urls.size}", @extraction)

          product_urls.each do |url|
            nested_page = try_get_url(@extraction, url)
            next if nested_page.nil?

            new_instance = Instance.create(extraction_id: @extraction.id, parent_id: @parent_stack[-1])
            nested_row = row['postprocessing'][0]['data']

            iterate_json(nested_row, nested_page, new_instance)
          end

          @parent_stack.pop
        end
      end
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
      return @post.extract_href(doc, row['xpath']) if @post.is_nested(row['postprocessing'])
      value = @post.extract_text(doc, row['xpath'])
      return value.to_s.strip if @post.is_whitespace(row['postprocessing'])
      value
    end

  end
end
