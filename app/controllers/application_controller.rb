class ApplicationController < ActionController::Base
  include DeviseTokenAuth::Concerns::SetUserByToken
  include Concerns::Render
  include CanCan::ControllerAdditions

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :json_api

  # Instead of rising exception or returning null when there is no record, let's return proper response.
  rescue_from ActiveRecord::RecordNotFound do |e|
    render_errors_json(messages: e.message, status: :not_found)
  end

  rescue_from CanCan::AccessDenied do |e|
    render_errors_json(messages: e.message, status: :forbidden)
  end

protected

  def json_api
    if request.headers["Content-Type"] ==  'application/vnd.api+json'
      req = JSON.parse(request.body.read)
      data = req["data"]
      params[data["type"].singularize] = ActiveSupport::HashWithIndifferentAccess.new(data["attributes"])
      data["relationships"].each_key do |relationship|
        rel_data = data["relationships"][relationship]["data"]
        if rel_data.present?
          params[data["type"].singularize][relationship + "_id"] = rel_data["id"]
          if rel_data["type"]
            params[data["type"].singularize][relationship + "_type"] = rel_data["type"].singularize.capitalize
          end
        end
      end
    end
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << :role
  end
end
