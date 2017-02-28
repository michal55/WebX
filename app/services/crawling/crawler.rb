module Crawling
  module Crawler
    extend self

    def execute(script)
      script_json = script.xpaths
      extraction = Extraction.new
      extraction.script = script
      extraction.save!

      Logging::Logger.debug('Extraction created', extraction, script.mode)

      # exit when opening URL fails
      begin
        @doc = Nokogiri::HTML(open(script_json['url']))
      rescue Exception => e
        Logging::Logger.error("#{e.to_s} url: #{script_json['url']}", extraction, script.mode)
        extraction.success = false
        extraction.save!
        exit
      end

      script.last_run = Time.now
      script.save!

      script_json['data'].each do |x|
        extraction_datum               = ExtractionDatum.new
        extraction_datum.extraction_id = extraction.id
        extraction_datum.field_name    = x['name']
        extraction_datum.value         = @doc.xpath x['value']
        extraction_datum.save!
        extraction_datum

        Logging::Logger.debug("field: #{x['name']}, xpath: #{x['value']}, value: #{extraction_datum.value}", extraction, script.mode)
      end

      extraction.execution_time = script.last_run - extraction.created_at
      extraction.success = true
      extraction.save!

      Logging::Logger.debug("Execution time: #{extraction.execution_time}", extraction, script.mode)
    end

  end
end