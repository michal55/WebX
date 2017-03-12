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
    flash[:notice] = I18n.t('scripts.flash_create', script_name: @script_new.name)
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
    respond_to do |format|
      format.text { render(nothing: true, status: 200, content_type: "text/html") }
      format.js { render :js => "flash(\"#{ I18n.t('scripts.flash_update', script_name: @script.name)}\");"  }
    end
  end

  def destroy
    @script = Script.find(params[:id])
    @script.destroy!
    flash[:notice] = I18n.t('scripts.flash_delete', script_name: @script.name)
    redirect_to project_path(params[:project_id])
  end
end
