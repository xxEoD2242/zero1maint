# frozen_string_literal: true

class UsersController < ApplicationController
  load_and_authorize_resource
  check_authorization

  def all_users
    @users = User.all
  end
  
  def manage_users
    @users = User.all
  end
  
  def dashboard
    
  end

  def update_user
    @user = User.find(params[:user_id])
    @user.update(role: params[:role])
    
    flash[:alert] = 'Role Successfully Updated!!'
    redirect_back(fallback_location: root_path)
  end

  def profile
    @user = User.find(params[:id])
    @requests = @user.requests
  end

  def assigned_work_orders
    @user = User.find(current_user.id)
    @q = @user.requests.where('status != ?', 'Completed').ransack(params[:q])
    @requests = @q.result.page(params[:page])
  end

  def completed_work_orders
    @user = User.find(current_user.id)
    @q = @user.requests.where(status: 'Completed').ransack(params[:q])
    @requests = @q.result.page(params[:page])
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy

    redirect_to root_url, notice: 'User deleted.' if @user.destroy
    end
end
