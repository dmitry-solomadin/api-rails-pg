module Concerns::Render
  extend ActiveSupport::Concern

private

  def render_errors_json(messages:, status:)
    messages = Array(messages).map { |message| Array(message) }

    render json: {
      errors: messages.map do |message|
        {
          status: Rack::Utils::SYMBOL_TO_STATUS_CODE[status],
          title: status.to_s.humanize,
          source: { attribute: message.size > 1 ? message.first : '' },
          message: Array(message.last).join(', ')
        }
      end
    }, status: status
  end
end
