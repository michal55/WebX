module Crawling
  module Crawler
    extend self

    def execute(script)
      script_json = script.xpaths
      extraction = Extraction.new
      extraction.script_id = script.id
      extraction.save!

      Logging::Logger.debug('Extraction created', extraction.id, 'extraction')

      # exit when opening URL fails
      begin
        @doc = Nokogiri::HTML(open(script_json['url']))
      rescue Exception => e
        Logging::Logger.error(e.to_s, extraction.id, 'extraction')
        extraction.success = false
        extraction.save!
        exit
      end

      script.last_run = Time.now
      script.save!

      script_json['data'].each do |x|
        extraction_datum = ExtractionDatum.new
        extraction_datum.extraction_id = extraction.id
        extraction_datum.field_name = x['name']
        extraction_datum.value = @doc.xpath x['value']
        extraction_datum.save!

        Logging::Logger.debug("field: #{x['name']}, xpath: #{x['value']}, value: #{extraction_datum.value}", extraction.id, 'extraction')
      end

      extraction.execution_time = script.last_run - extraction.created_at
      extraction.success = true
      extraction.save!

      Logging::Logger.debug("Execution time: #{extraction.execution_time}", extraction.id, 'extraction')

    end
  end
end