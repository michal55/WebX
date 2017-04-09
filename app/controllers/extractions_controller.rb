class ExtractionsController < ApplicationController

  def index
    @script = Script.find(params[:script_id])
    @extraction = Extraction.where(script_id: @script.id).order('created_at DESC').page params[:page]
    @project = Project.find(params[:project_id])
    authorize! :index, Script.find(params[:script_id])
  end
end
