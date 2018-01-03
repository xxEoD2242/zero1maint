class ApplicationController < ActionController::Base
  
  protect_from_forgery with: :exception
  
  
  before_action :configure_permitted_parameters, if: :devise_controller?
  protected

  rescue_from CanCan::AccessDenied do |exception|
      flash[:error] = exception.message
      redirect_to root_url
    end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :name, :bio, :location, :role, :emplyid, :labor])
    devise_parameter_sanitizer.permit(:account_update, keys: [:username, :name, :bio, :location, :role, :emplyid, :labor])
  end
end
