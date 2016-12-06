class DataSchemasController < ApplicationController

  def index
    @project = Project.find(params[:project_id])
    @data_schema = DataSchema.where(project: @project)
    @data_schema_new = DataSchema.new
    @data_schema_new.project = @project

  end

  def create
    @data_schema = DataSchema.new
    @data_schema.assign_attributes({name: params[:data_schema][:name], data_type: params[:data_schema][:data_type].to_i , project_id:  params[:project_id] })
    @data_schema.save!
    redirect_to project_path(params[:project_id])
  end

  def edit
    @data_schema = DataSchema.find(params[:id])
    @project = @data_schema.project
  end

  def update
    @data_schema = DataSchema.find(params[:id])
    @data_schema.name = params[:data_schema][:name]
    @data_schema.data_type = params[:data_schema][:data_type].to_i
    @data_schema.save!
    redirect_to project_data_schemas_path
  end

  def destroy
    @data_schema = DataSchema.find(params[:id])
    @data_schema.destroy!
    redirect_to project_path(params[:project_id])
  end
end
