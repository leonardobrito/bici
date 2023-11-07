# frozen_string_literal: true

module Users
  class OmniauthCallbacksController < Devise::OmniauthCallbacksController
    def strava
      unless ::User::Authenticate::ValidOmniauthProvider.new(oauth_provider: oauth.provider).call
        redirect_to_registration
      end

      persisted, user = ::User::Authenticate::ByOmniauthStrava.new(oauth: oauth).call

      persisted ? authenticate!(user) : redirect_to_registration
    end

    def failure
      flash[:error] = "Error logging in #{omniauth_error}"
      redirect_to root_path
    end

    private

    def authenticate!(user)
      session[:access_token] = credentials_token
      sign_in_and_redirect user, event: :authentication
      set_flash_message(:notice, :success, kind: "strava") if is_navigational_format?
    end

    def redirect_to_registration
      redirect_to new_user_registration_url
    end

    def credentials_token
      oauth.credentials.token
    end

    def oauth
      request.env["omniauth.auth"]
    end

    def omniauth_error
      request.env["omniauth.error"]
    end
  end
end
