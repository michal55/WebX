class ScriptsController < ApplicationController
  load_and_authorize_resource :except => [:create, :new]
  def index
    @scripts = Script.where(project_id: params[:project_id])
    @project = Project.find(params[:project_id])
    authorize! :read, @project
  end

  def new
    @script_new = Script.new
    @script_new.project_id = params[:project_id]
    @project = Project.find(params[:project_id])
    authorize! :read, @project
  end

  def create
    @script_new = Script.new
    @script_new.assign_attributes({name: params[:script][:name], project_id:  params[:project_id] })
    @script_new.xpaths = {}.to_json
    @script_new.save!
    redirect_to project_path(params[:project_id])
  end

  def show
    @script = Script.find(params[:id])
    @project = Project.find(params[:project_id])
    @new_frequency = Frequency.new(script: @script)
  end

  def edit
    @script = Script.find(params[:id])
    @project = Project.find(params[:project_id])
    authorize! :read, @project
  end

  def update
    @script = Script.find(params[:id])
    @script.name = params[:script][:name]
    puts params[:script][:xpaths]
    @script.xpaths = params[:script][:xpaths].gsub("\n","").to_json
    @script.save!
    render nothing: true, status: 200, content_type: "text/html"
  end

  def destroy
    @script = Script.find(params[:id])
    @script.destroy!
    redirect_to project_path(params[:project_id])
  end
end
