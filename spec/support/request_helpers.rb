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

  module AuthenticationHelpers
    def login_as(user)
      @request.env['devise.mapping'] = Devise.mappings[:user]
      sign_in :user, user
    end

    [:post, :put, :delete, :patch].each do |m|
      define_method "#{m}_as_user" do |url, opts = {}|
        client_id = SecureRandom.urlsafe_base64(nil, false)
        token     = SecureRandom.urlsafe_base64(nil, false)

        user.tokens[client_id] = {
          token: BCrypt::Password.create(token),
          expiry: (Time.now + DeviseTokenAuth.token_lifespan).to_i
        }

        user.save

        send(m, url, opts, user.build_auth_header(token, client_id))
      end
    end
  end
end

RSpec.configure do |config|
  config.include Requests::JsonHelpers
  config.include Requests::AuthenticationHelpers
end
