# frozen_string_literal: true

module User
  module Authenticate
    class ValidOmniauthProvider
      include ActiveModel::Model
      include ActiveModel::Attributes

      ALLOWED_PROVIDERS = ["strava"].freeze

      attribute :oauth_provider

      def call
        ALLOWED_PROVIDERS.include?(oauth_provider)
      end
    end
  end
end
