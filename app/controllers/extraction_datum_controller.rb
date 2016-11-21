class ExtractionDatumController < ApplicationController
  def index
  	@extraction = Extraction.find(params[:extraction_id])
  	@extraction_datum = ExtractionDatum.where(extraction_id: @extraction.id)
  	@script = Script.find(params[:script_id])
  	@project = Project.find(params[:project_id])
  end
end
