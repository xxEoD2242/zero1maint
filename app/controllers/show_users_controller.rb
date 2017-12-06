class ShowUsersController < ApplicationController
  before_action :authenticate_user!
  def all_users
    @users = User.all
  end
end
