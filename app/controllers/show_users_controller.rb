# frozen_string_literal: true

class ShowUsersController < ApplicationController
  def all_users
    @users = User.all
  end

  def show
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
