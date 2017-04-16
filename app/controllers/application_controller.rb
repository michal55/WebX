class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  before_action :authenticate_user!
  protect_from_forgery with: :exception
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to Rails.configuration.relative_url_root + '/401.html', :alert => exception.message
  end

  def home
    projects_ids = Project.where(user_id: current_user.id).pluck(:id)
    scripts_ids = Script.where(project_id: projects_ids)
    @extractions = Extraction.where(script_id: scripts_ids).order("created_at DESC").limit(5)
    @active_scripts = Script.where(id: Frequency.all.pluck(:script_id))
        .joins(:extractions).group("scripts.id").order("max (extractions.updated_at) desc")
  end


end
