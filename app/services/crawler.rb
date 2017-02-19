module Crawler
  extend self
  def execute(script)
    script_json = script.xpaths
    log = {}
    log['status'] = ""
    log['url'] = script_json['url']
    begin
      @doc = Nokogiri::HTML(open(script_json['url']))
    rescue Exception => e
      log['status'] = e.to_s
      puts log
      exit
    end

    log['html'] = @doc.to_s
    log['xpaths'] = []

    extraction = Extraction.new
    extraction.script_id = script.id
    extraction.save!
    script.last_run = Time.now
    script.save!

    script_json['data'].each do |x|
      subarray = []
      extraction_datum = ExtractionDatum.new
      extraction_datum.extraction_id = extraction.id
      extraction_datum.field_name = x['name']
      extraction_datum.value = @doc.xpath assert_text x['value']

      subarray.push(x['value'])
      subarray.push(x['name'])
      subarray.push(extraction_datum.value)

      extraction_datum.save!
      log['xpaths'].push(subarray)
    end

    extraction.execution_time = script.last_run - extraction.created_at
    extraction.success = true
    extraction.save!

    log['exec_time'] = extraction.execution_time
    log['status'] = extraction.success

    puts log.to_json

  end

#check whether xpath ends with text()
  def assert_text xpath
    return xpath if xpath[-6..-1].eql?("text()")
    "#{xpath}/text()"
  end
end
