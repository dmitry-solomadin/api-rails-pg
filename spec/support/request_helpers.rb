module Requests
  module JsonHelpers
    def json
      JSON.parse(response.body)
    end

    def json_helper(*args, include: [])
      raise ArgumentError, 'expect objects' unless args.first.class < ActiveRecord::Base

      serializer_klass = "#{args.first.class}Serializer".constantize
      objects_for_serialization = args.map { |o| serializer_klass.new(o) }
      objects_for_serialization = objects_for_serialization.first if objects_for_serialization.count == 1

      ActiveModel::Serializer::Adapter::JsonApi.create(objects_for_serialization, include: include).to_json
    end

    def empty_json_data
      ActiveModel::Serializer::Adapter::JsonApi.create([]).to_json
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
