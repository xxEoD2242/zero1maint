# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?

  before_action :authenticate_user!

  protected
  
  # CanCan has to actually be turned on first
  # rescue_from CanCan::AccessDenied do |exception|
  #  flash[:error] = exception.message
  #  redirect_to root_url
  # end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[username name bio location role emplyid labor subscribe])
    devise_parameter_sanitizer.permit(:account_update, keys: %i[username name bio location role emplyid labor subscribe])
  end
end
