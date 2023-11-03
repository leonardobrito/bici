# frozen_string_literal: true

module Users
  class OmniauthCallbacksController < Devise::OmniauthCallbacksController
    def strava
      @user = User.from_omniauth(request.env["omniauth.auth"])
      session[:access_token] = request.env["omniauth.auth"].credentials.token

      if @user.persisted?
        sign_in_and_redirect @user, event: :authentication # this will throw if @user is not activated
        set_flash_message(:notice, :success, kind: "strava") if is_navigational_format?
      else
        redirect_to new_user_registration_url
      end
    end

    def failure
      flash[:error] = "Error logging in #{request.env['omniauth.error']}"
      redirect_to root_path
    end
  end
end
