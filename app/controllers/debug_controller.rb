class DebugController < ApplicationController
  def home
    @user_count = User.all.count
  end

  def api_export_instructions

  end
end
