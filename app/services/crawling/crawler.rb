module Crawling
  module Crawler
    extend self

    def execute(script)
      @logger = Logging::Logger.new(severity: script.log_level)
      @agent = Mechanize.new
      script_json = script.xpaths
      extraction = Extraction.create(script: script)
      @logger.debug('Extraction created', extraction)

      # exit when opening URL fails
      @doc = try_get_url(extraction, script_json['url'])
      exit if @doc.nil?

      script.last_run = Time.now
      script.save!

      instance = Instance.create(extraction_id: extraction.id)
      script_json['data'].each do |row|
        extraction_datum = ExtractionDatum.create(
            instance_id: instance.id, extraction_id: extraction.id,
            field_name: row['name'], value: extract_value(@doc, row)
        )
        @logger.debug(log_msg(extraction_datum, row), extraction)

        if is_nested(row['postprocessing'])
          nested_page = try_get_url(extraction, extract_href(@doc, row['xpath']))
          exit if nested_page.nil?

          row['postprocessing'][0]['data'].each do |nested_row|  #TODO [0] upravit/doplnit
            extraction_datum = ExtractionDatum.create(
                instance_id: instance.id, extraction_id: extraction.id,
                field_name: nested_row['name'], value: extract_value(nested_page, nested_row)
            )
            @logger.debug(log_msg(extraction_datum, nested_row), extraction)
          end
        end
      end

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
      is_nested(row['postprocessing']) ? extract_href(doc, row['xpath']) : extract_text(doc, row['xpath'])
    end

    def is_nested(row)
      #TODO: kontrola na array nemusi byt idealna, uvidime co do toho jsonu este pribudne
      row.is_a?(Array) and row.size > 0 and row[0]['type'] == "nested"
    end

    def extract_text doc, xpath
      if xpath[-7..-1].eql?("/text()")
        doc.parser.xpath(xpath)
      else
        doc.parser.xpath "#{xpath}/text()"
      end
    end

    def extract_href doc, xpath
      doc.parser.xpath(xpath)[0].attributes['href']
    end

  end
end