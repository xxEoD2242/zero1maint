class ShowUsersController < ApplicationController
  def all_users
    @users = User.all
  end
end
