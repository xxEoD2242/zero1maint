class ShowUsersController < ApplicationController
  before_action :authenticate_user!
  def all_users
    @users = User.all
  end
  
  def show
    @user = User.find(params[:id])
    @requests = @user.requests
  end
  
  def assigned_work_orders
    @user = User.find(current_user.id)
    @q = @user.requests.ransack(params[:q])
    @requests = @q.result
    @set_new = Tracker.find_by(track: "New")
    @set_progress = Tracker.find_by(track: "In-Progress")
    @set_completed = Tracker.find_by(track: "Completed")
    @set_overdue = Tracker.find_by(track: "Overdue")
  end
  
  def completed_work_orders
    @user = User.find(current_user.id)
    @q = @user.requests.ransack(params[:q])
    @requests = @q.result
    @set_completed = Tracker.find_by(track: "Completed")
  end
  
  def destroy
      @user = User.find(params[:id])
      @user.destroy

      if @user.destroy
          redirect_to root_url, notice: "User deleted."
      end
    end
end
