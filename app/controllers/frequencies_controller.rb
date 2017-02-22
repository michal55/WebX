class FrequenciesController < ApplicationController
  def create
    @frequency_new = Frequency.new
    @frequency_new.assign_attributes({script_id: params[:script_id], interval: params[:frequency][:interval], period: params[:frequency][:period], first_exec: params[:frequency][:first_exec], last_run: nil})
    @frequency_new.save!
    redirect_to :back
  end

  def new
    @frequency_new = Frequency.new
    @script = Script.find(params[:script_id])
    @project = Project.find(params[:project_id])
    @frequency_new.script_id = params[:script_id]
  end

  def index
    @frequencies = Frequency.where(script_id: params[:script_id])
    @script = Script.find(params[:script_id])
    @project = Project.find(params[:project_id])
  end

  def edit
    @frequency = Frequency.find(params[:id])
    @script = Script.find(params[:script_id])
    @project = Project.find(params[:project_id])
    authorize! :read, @project
  end

  def update
    @frequency = Frequency.find(params[:id])
    @frequency.interval = params[:frequency][:interval]
    @frequency.period = params[:frequency][:period]
    @frequency.first_exec = params[:frequency][:first_exec]
    @frequency.save!
    redirect_to project_script_path(params[:project_id], params[:script_id])
  end

  def destroy
    @frequency = Frequency.find(params[:id])
    @frequency.destroy!
    redirect_to :back
  end

end
