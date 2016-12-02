module Crawler
  extend self
  def execute(script)
    script_json = script.xpaths
    @doc = Nokogiri::HTML(open(script_json['url']))
    extraction = Extraction.new
    extraction.script_id = script.id
    extraction.save!
    script.last_run = Time.now
    script.save!

    script_json['data'].each do |x|
      extraction_datum = ExtractionDatum.new
      extraction_datum.extraction_id = extraction.id
      extraction_datum.field_name = x['name']
      extraction_datum.value = @doc.xpath assert_text x['value']
      extraction_datum.save!
    end

    extraction.execution_time = script.last_run - extraction.created_at
    extraction.success = true
    extraction.save!

  end

#check whether xpath ends with text()
  def assert_text xpath
    return xpath if xpath[-6..-1].eql?("text()")
    "#{xpath}/text()"
  end
end
