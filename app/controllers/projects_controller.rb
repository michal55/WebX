class ProjectsController < ApplicationController
  load_and_authorize_resource :except => [:create]
#  skip_authorize_resource :only => [:new, :index, :create]
  def index
    @projects = Project.where(user_id: current_user.id)
  end

  def create
    @project_new = Project.new
    @project_new.assign_attributes({name: params[:project][:name], user_id: current_user.id})
    @project_new.save!
    redirect_to projects_path
  end

  def new
    @project_new = Project.new
  end

  def edit
    @project = Project.find(params[:id])
  end

  def show
    @project = Project.find(params[:id])
    @scripts = Script.where(project_id: params[:id])

    @data_schema = DataSchema.where(project: @project)
    @data_schema_new = DataSchema.new
    @data_schema_new.project = @project

    authorize! :read, @project
  end

  def update
    @project = Project.find(params[:id])
    @project.name = params[:project][:name]
    @project.save!
    render nothing: true, status: 200, content_type: "text/html"
  end

  def destroy
    @project = Project.find(params[:id])
    @project.destroy!
    redirect_to projects_path
  end

end
