class FrequenciesController < ApplicationController
  def create
    @frequency_new = Frequency.new
    @frequency_new.assign_attributes({script_id: params[:script_id], interval: params[:frequency][:interval], period: params[:frequency][:period], first_exec: params[:frequency][:first_exec]})
    @frequency_new.save!
    redirect_to project_script_frequencies_path
  end

  def new
    @frequency_new = Frequency.new
    @script = Script.find(params[:script_id])
    @project = Project.find(params[:project_id])
    @frequency_new.script_id = params[:script_id]
  end

  def index
    @frequency = Frequency.where(script_id: params[:script_id])
  end
end
