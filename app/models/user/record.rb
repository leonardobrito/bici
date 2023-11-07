# frozen_string_literal: true

module User
  class Record < ApplicationRecord
    self.table_name = "users"
    update_index("users") { self }

    # Include default devise modules. Others available are:
    # :confirmable, :lockable, :timeoutable and :trackable
    devise :database_authenticatable, :registerable,
      :recoverable, :rememberable, :validatable, :api, :omniauthable, omniauth_providers: %i[strava]

    validates :email, uniqueness: { case_sensitive: false }

    def email_required?
      false
    end
  end
end
