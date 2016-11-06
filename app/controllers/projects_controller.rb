class ProjectsController < ApplicationController

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

  def update
    @project = Project.find(params[:id])
    @project.name = params[:project][:name]
    @project.save!
    redirect_to projects_path
  end

  def destroy
    @project = Project.find(params[:id])
    @project.destroy!
    redirect_to projects_path
  end

end
