class ExtractionsController < ApplicationController
  def index
    @script = Script.find(params[:script_id])
    @extraction = Extraction.where(script_id: @script.id)
    @project = Project.find(params[:project_id])
  end
end
