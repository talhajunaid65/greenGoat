class ApplicationController < ActionController::Base
  protect_from_forgery unless: -> { request.format.json? }
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    added_attrs = [:firstname, :lastname, :email, :password, :password_confirmation,
             :phone, :phone_type, :address1, :address2, :city, :state, :zip, :dob, :image, roles: []]
    devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
    devise_parameter_sanitizer.permit :account_update, keys: added_attrs
  end
end
