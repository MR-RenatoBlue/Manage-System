class UsersController < ApplicationController
  include Pagy::Backend
  before_action :authenticate_user!
  before_action :admin_only
  def index
    @pagy, @users = pagy(User.order(created_at: :desc))
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to users_path, notice: "User was sucessfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end
  
  def show
    @user = User.find(params[:id])
  end

  def create

  end

  private
    def admin_only
      unless current_user.has_role? :admin
        redirect_to root_path, alert: "Access Denied."
      end
    end

    def user_params
      params.require(:user).permit({role_ids: []}, :is_active)
    end

end