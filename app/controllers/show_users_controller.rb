class ShowUsersController < ApplicationController
  before_action :authenticate_user!
  def all_users
    @users = User.all
  end
  
  def show
    @user = User.find(params[:id])
    @requests = Request.where(creator: @user.name)
  end
  
  def destroy
      @user = User.find(params[:id])
      @user.destroy

      if @user.destroy
          redirect_to root_url, notice: "User deleted."
      end
    end
end
