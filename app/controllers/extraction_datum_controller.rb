class ExtractionDatumController < ApplicationController
  require 'set'
  include ExtractionDatumMapper

  def index
    @extraction = Extraction.find(params[:extraction_id])
    @children = Instance.where(extraction_id: @extraction.id).where(is_leaf: true).order('id ASC').page params[:page]

    @parents = ExtractionDatumMapper.get_parents(@children)

    @script = Script.find(params[:script_id])
  	@project = Project.find(params[:project_id])

    @fields_array = ExtractionDatumMapper.get_field_array(@parents,@children)

  end


end
