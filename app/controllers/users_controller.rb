class UsersController < ApplicationController
  load_and_authorize_resource :unless => :devise_controller?

  def new
    @user = User.new
  end

  def index
    @users = User.all
    # puts current_user.role if current_user.role.to_sym
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to @user
    else
      render 'new'
    end
  end

  def show
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:login, :password)
  end
end
