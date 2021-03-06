class Api::UsersController < ApplicationController
  before_action :logged_in_user, only: [:destory, :update]

  def index 
    @users = User.order('updated_at DESC')
  end


  def show 
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create 
    @user = User.new(user_params)
    if @user.save
      @user.categories.create(title: 'Inbox', user_id: @user.id, fixed: true)
      log_in @user
      render json: { email: @user.email, id: @user.id, categories: @user.categories, tasks: [] }
    else
      render json: { ErrorMesage: 'Your e-mail is already in use.' }, status: :forbidden
    end
  end

  private 
  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end

  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_user) unless current_user?(@user)
  end

  def admin_user
    redirect_to(root_user) unless current_user.admin
  end
end
