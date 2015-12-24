class ApplicationController < ActionController::Base
  include DeviseTokenAuth::Concerns::SetUserByToken
  include Concerns::Render
  include CanCan::ControllerAdditions

  before_action :configure_permitted_parameters, if: :devise_controller?

  # Instead of rising exception or returning null when there is no record, let's return proper response.
  rescue_from ActiveRecord::RecordNotFound do |e|
    render_errors_json(messages: e.message, status: :not_found)
  end

  rescue_from CanCan::AccessDenied do |e|
    render_errors_json(messages: e.message, status: :forbidden)
  end

protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << :role
  end
end
