module Crawling
  module Crawler
    extend self

    def execute(script)
      logger = Logging::Logger.new(severity: script.log_level)
      script_json = script.xpaths
      extraction = Extraction.new
      extraction.script = script
      extraction.save!

      logger.debug('Extraction created', extraction)

      agent = Mechanize.new
      # exit when opening URL fails
      begin
        @doc = agent.get(script_json['url'])
      rescue Exception => e
        logger.error("#{e.to_s} url: #{script_json['url']}", extraction)
        extraction.success = false
        extraction.save!
        exit
      end

      script.last_run = Time.now
      script.save!
      instance = Instance.create(extraction_id: extraction.id)

      script_json['data'].each do |row|

        extraction_datum               = ExtractionDatum.new
        extraction_datum.extraction_id = extraction.id
        extraction_datum.instance_id   = instance.id
        extraction_datum.field_name    = row['name']
        extraction_datum.value         = postprocessing(row) ? extract_url(@doc, row['xpath']) : extract_text(@doc, row['xpath'])
        extraction_datum.save
        logger.debug("field: #{row['name']}, xpath: #{row['xpath']}, value: #{extraction_datum.value}", extraction)

        if postprocessing(row)
          begin
            nested_page = agent.get(extract_url @doc, row['xpath'])
          rescue Exception => e
            logger.error("#{e.to_s} url: #{extraction_datum.value}", extraction)
            extraction.success = false
            extraction.save!
            exit
          end

          row['postprocessing'][0]['data'].each do |nested_row|
            extraction_datum            = ExtractionDatum.create(instance_id: instance.id, extraction_id: extraction.id)
            extraction_datum.field_name = nested_row['name']
            extraction_datum.value      = extract_text nested_page, nested_row['xpath']
            extraction_datum.save
            logger.debug("field: #{nested_row['name']}, xpath: #{nested_row['xpath']}, value: #{extraction_datum.value}", extraction)
          end
        end
      end

      extraction.execution_time = script.last_run - extraction.created_at
      extraction.success = true
      extraction.save!

      logger.debug("Execution time: #{extraction.execution_time}", extraction)
    end

    def postprocessing(row)
      #TODO: kontrola na array nemusi byt idealna, uvidime co do toho jsonu este pribudne
      row['postprocessing'].is_a?(Array) and row['postprocessing'][0]['type'] == "nested"
    end

    def extract_text doc, xpath
      if xpath[-7..-1].eql?("/text()")
        doc.parser.xpath(xpath)
      else
        doc.parser.xpath "#{xpath}/text()"
      end
    end

    def extract_url doc, xpath
      doc.parser.xpath(xpath)[0].attributes['href']
    end

  end
end