class Users::RegistrationsController < Devise::RegistrationsController
  before_action :check_permissions, :only => [:new, :create, :cancel, :update, :destroy]
  skip_before_action :require_no_authentication
 
  def check_permissions
    authorize! :create, resource
    authorize! :destroy, resource
    authorize! :update, resource
  end
  

end