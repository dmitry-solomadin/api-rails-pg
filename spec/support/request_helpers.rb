module Requests
  module JsonHelpers
    def json
      JSON.parse(response.body)
    end

    def to_json(*args)
      raise ArgumentError, 'expect objects' unless args.first.class < ActiveRecord::Base
      args.map { |o| o }.to_json
    end

    def empty_json_data
      [].to_json
    end
  end
end

RSpec.configure do |config|
  config.include Requests::JsonHelpers
end
