class ProjectsController < ApplicationController
  load_and_authorize_resource :except => [:create]
#  skip_authorize_resource :only => [:new, :index, :create]

  def index
    @project_new = Project.new
    @projects = Project.where(user_id: current_user.id)
  end

  def create
    @project_new = Project.new
    @project_new.assign_attributes({name: params[:project][:name], user_id: current_user.id})
    @project_new.save!
    flash[:notice] = I18n.t('projects.flash_create', project_name: @project_new.name)
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

    @data_field = DataField.where(project: @project)
    @data_field_new = DataField.new
    @data_field_new.project = @project

    @script_new = Script.new
    @script_new.project_id = params[:project_id]

    authorize! :read, @project
  end

  def update
    @project = Project.find(params[:id])
    @project.name = params[:project][:name]
    flash[:notice] =  I18n.t('projects.flash_update', project_name: @project.name)
    @project.save!
    respond_to do |format|
      format.text { render(nothing: true, status: 200, content_type: "text/html") }
      format.js { render :js => "flash();"  }
    end

  end

  def destroy
    @project = Project.find(params[:id])
    flash[:notice] = I18n.t('projects.flash_delete', project_name: @project.name)
    @project.destroy!
    redirect_to projects_path
  end


end
