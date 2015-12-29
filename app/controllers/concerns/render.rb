module Concerns::Render
  extend ActiveSupport::Concern

private

  def render_json(obj, opts = {})
    render({ json: obj, include: params[:include] }.merge!(opts))
  end

  def render_errors_json(messages:, status:)
    messages = Array(messages).map { |message| Array(message) }

    render json: {
      errors: messages.map do |message|
        {
          status: Rack::Utils::SYMBOL_TO_STATUS_CODE[status],
          title: status.to_s.humanize,
          source: { pointer: message.size > 1 ? "/data/attributes/#{message.first}" : '' },
          detail: Array(message.last).join(', ')
        }
      end
    }, status: status
  end
end
