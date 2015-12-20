class ApplicationController < ActionController::Base
  include Concerns::Render

  # Instead of rising exception or returning null when there is no record, let's return proper response.
  rescue_from ActiveRecord::RecordNotFound do |e|
    render_errors_json(messages: e.message, status: :not_found)
  end
end
