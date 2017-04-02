class UsersController < ApplicationController
  load_and_authorize_resource :unless => :devise_controller?
  #
  # def new
  #   @user = User.new
  # end

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    @user.role = params[:user][:role]

    @user.save!
    redirect_to profile_path(@user)
  end

  def profile
    @user = User.find(params[:id])
  end

end
