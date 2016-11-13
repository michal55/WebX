class DataSchemasController < ApplicationController

  def index
    @project = Project.find(params[:project_id])
    @data_schema = DataSchema.where(project: @project)
  end

  def new
    @project = Project.find(params[:project_id])
    @data_schema = DataSchema.new
    @data_schema.project = @project
  end

  def create
    @data_schema = DataSchema.new
    @data_schema.assign_attributes({name: params[:data_schema][:name], data_type: params[:data_schema][:data_type].to_i , project_id:  params[:project_id] })
    @data_schema.save!
    redirect_to project_data_schemas_path
  end
end
