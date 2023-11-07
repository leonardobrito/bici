# frozen_string_literal: true

module User
  module Authenticate
    class ByOmniauthStrava
      include ActiveModel::Model
      include ActiveModel::Attributes

      attribute :oauth
      attribute :repository, default: ::User::Repository

      def call
        user = repository.find_or_create_by_oauth(oauth: oauth)

        [user.persisted?, user]
      end
    end
  end
end
