module Crawling
  module Crawler
    extend self

    def execute(script)
      @logger = Logging::Logger.new(severity: script.log_level)
      @agent = Mechanize.new
      @post = Postprocessing.new
      script_json = script.xpaths
      extraction = Extraction.create(script: script)
      @logger.debug('Extraction created', extraction)

      # exit when opening URL fails
      @doc = try_get_url(extraction, script_json['url'])
      return if @doc.nil?

      script.last_run = Time.now
      script.save!

      parent_stack = []

      instance = Instance.create(extraction_id: extraction.id)
      instance.parent_id = instance.id.save
      parent_stack.push(instance.id)
      script_json['data'].each do |row|
        extraction_datum = ExtractionDatum.create(
            instance_id: instance.id, extraction_id: extraction.id,
            field_name: row['name'], value: extract_value(@doc, row)
        )
        @logger.debug(log_msg(extraction_datum, row), extraction)

        if @post.is_nested(row['postprocessing'])
          product_urls = @post.extract_href(@doc, row['xpath'])
          product_urls.each do |url|
            nested_page = try_get_url(extraction, url)
            next if nested_page.nil?

            new_instance = Instance.create(extraction_id: extraction.id, parent_id: parent_stack[-1])
            row['postprocessing'][0]['data'].each do |nested_row|  #TODO [0] upravit/doplnit
              extraction_datum = ExtractionDatum.create(
                  instance_id: new_instance.id, extraction_id: extraction.id,
                  field_name: nested_row['name'], value: extract_value(nested_page, nested_row)
              )
              @logger.debug(log_msg(extraction_datum, nested_row), extraction)
            end
          end
        end
      end
      parent_stack.pop

      extraction.execution_time = script.last_run - extraction.created_at
      extraction.success = true
      extraction.save!
      @logger.debug("Execution time: #{extraction.execution_time}", extraction)
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
      return value.to_s.strip if @post.strip_whitespace(row['postprocessing'])
      value
    end

    def test_url
      agent = Mechanize.new
      # doc = agent.get("https://www.alza.sk/lenovo-ideapad-700-15isk-gaming?dq=4162924&catid=18848814")
      doc = agent.get("https://www.alza.sk/notebooky/podla-vyuzitia/hracie/18848814.htm")

      # '//*[@id="prices"]/tbody/tr[3]/td/div/div/div[1]/div[2]/span[2]'
      # xpath = '//*[contains(@class, "categoryPageTitle")]'
      xpath = '//*[@id="boxes"]/div/div[2]/div[1]/a'
      puts doc.parser.xpath(xpath)
    end
  end
end