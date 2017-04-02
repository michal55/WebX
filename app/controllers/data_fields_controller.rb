class DataFieldsController < ApplicationController

  def index
    @project = Project.find(params[:project_id])
    @data_field = DataField.where(project: @project)
    @data_field_new = DataField.new
    @data_field_new.project = @project

  end

  def create
    @data_field = DataField.new
    @data_field.assign_attributes({name: params[:data_field][:name], data_type: params[:data_field][:data_type].to_i , project_id:  params[:project_id] })
    @data_field.save!
    flash[:notice] = I18n.t('data_fields.flash_create', field_name: @data_field.name)
    redirect_to project_path(params[:project_id])
  end

  def edit
    @data_field = DataField.find(params[:id])
    @project = @data_field.project
  end

  def update
    @data_field = DataField.find(params[:id])
    @data_field.name = params[:data_field][:name]
    @data_field.data_type = params[:data_field][:data_type].to_i
    @data_field.save!
    flash[:notice] = I18n.t('data_fields.flash_update', field_name: @data_field.name)
    respond_to do |format|
      format.json {render(json: {'id': @data_field.id}, status: 200)}
    end

  end

  def destroy
    @data_field = DataField.find(params[:id])
    @data_field.destroy!
    flash[:notice] = I18n.t('data_fields.flash_delete', field_name: @data_field.name)
    redirect_to project_path(@data_field.project.id)
  end
end
