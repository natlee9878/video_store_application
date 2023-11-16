class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?



  def delete
    # Your logout logic here
    reset_session
    redirect_to root_url
  end

  protected
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :address_line, :suburb, :state, :role, :postcode])
    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name, :address_line, :suburb, :state, :role, :postcode])
  end
end
