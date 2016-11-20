class Script < ActiveRecord::Base
  # require 'nokogiri'
  belongs_to :project
  acts_as_paranoid
  validates :name, :presence => true

  def execute
    @doc = Nokogiri::HTML(open(self.url))
    extraction = Extraction.new
    extraction.script_id = self.id
    extraction.save
    schemas = self.project.data_schemas

    schemas.each do |s|
      extraction_datum = ExtractionDatum.new
      extraction_datum.extraction_id = extraction.id
      extraction_datum.field_name = s.name
      extraction_datum.value = @doc.xpath assert_text s.xpath
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
