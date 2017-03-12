class DebugController < ApplicationController
  def home
    @user_count = User.all.count
  end
end
