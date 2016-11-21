class Script < ActiveRecord::Base
  belongs_to :project
  acts_as_paranoid
  validates :name, :presence => true

  def execute
    @doc = Nokogiri::HTML(open(self.url))
    extraction = Extraction.new
    extraction.script_id = self.id
    extraction.save
    xpaths = self.xpaths

    xpaths.each do |x|
      extraction_datum = ExtractionDatum.new
      extraction_datum.extraction_id = extraction.id
      extraction_datum.field_name = x['name']
      extraction_datum.value = @doc.xpath assert_text x['value']
      extraction_datum.save
    end

    extraction.execution_time = Time.now - extraction.created_at
    extraction.success = true
    extraction.save

  end

  #check whether xpath ends with text()
  def assert_text xpath
    return xpath if xpath[-6..-1].eql?("text()")
    "#{xpath}/text()"
  end
end
