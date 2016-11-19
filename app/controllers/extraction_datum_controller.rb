class ExtractionDatumController < ApplicationController
  def index
  	@extraction = Extraction.find(1)
  	@extraction_datum = ExtractionDatum.where(extraction_id: 1)
  	@script = Script.find(1)
  	@project = Project.find(1)
  end
end
