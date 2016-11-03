module Api
  class Api::EchoController < ActionController::Base
    before_action :doorkeeper_authorize!
    respond_to :html

    def index
      respond_to do |format|
        format.html { render :json => { :message => params[:message] } }
      end
    end
  end
end
