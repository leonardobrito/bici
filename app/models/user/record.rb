# frozen_string_literal: true

module User
  class Record < ApplicationRecord
    self.table_name = "users"
    ALLOWED_PROVIDERS_HASH = { strava: "strava" }.freeze
    update_index("users") { self }

    # Include default devise modules. Others available are:
    # :confirmable, :lockable, :timeoutable and :trackable
    devise :database_authenticatable, :registerable,
      :recoverable, :rememberable, :validatable, :api, :omniauthable, omniauth_providers: %i[strava]

    validates :email, uniqueness: { case_sensitive: false }

    def email_required?
      false
    end

    def self.from_omniauth(auth)
      oauth_provider = auth.provider

      case oauth_provider
      when ALLOWED_PROVIDERS_HASH[:strava]
        find_or_create_by(oauth_provider: auth.provider, oauth_uid: auth.uid) do |user|
          user.email = auth.info.email
          user.password = Devise.friendly_token[0, 20]
          user.name = auth.info.name
        end
      end
    end
  end
end
