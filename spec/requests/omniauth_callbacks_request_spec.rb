# frozen_string_literal: true

require "rails_helper"

RSpec.describe "/users/auth/:provider", type: :system do
  describe "/users/auth/strava/callback" do
    subject(:do_request) { get user_strava_omniauth_callback_path }

    let(:callback_params) do
      {
        "provider" => "strava",
        "uid" => "1234",
        "info" => {
          "name" => "Athlete Name"
        },
        credentials: {
          token: "token"
        }
      }
    end

    before do
      mock_omni_auth(:strava, OmniAuth::AuthHash.new(callback_params))
    end

    context "when user does not exists" do
      it "creates user" do
        expect { do_request }.to(change(User, :count).by(1))
      end

      it "redirects to root page" do
        do_request
        expect(response).to redirect_to "/"
      end
    end

    context "when user exists" do
      before { create(:user, email: "user@company.com", oauth_provider: "strava", oauth_uid: "1234") }

      it "does not create user" do
        expect { do_request }.not_to(change(User, :count))
      end

      it "redirects to root page" do
        do_request
        expect(response).to redirect_to "/"
      end
    end
  end
end
