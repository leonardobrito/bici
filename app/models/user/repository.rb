# frozen_string_literal: true

module User
  module Repository
    extend self

    AsReadonly = ->(user) { user&.tap(&:readonly!) }

    def find_or_create_by_oauth(oauth:)
      ::User::Record.find_or_create_by(oauth_provider: oauth.provider, oauth_uid: oauth.uid) do |user|
        user.email = oauth.info.email
        user.password = Devise.friendly_token[0, 20]
        user.name = oauth.info.name
      end.then(&AsReadonly)
    end

    def find_user_by_oauth_uid(oauth_uid:)
      find_user_by(oauth_uid: oauth_uid)
    end

    private

    def find_user_by(args)
      ::User::Record.find_by(args).then(&AsReadonly)
    end
  end
end
