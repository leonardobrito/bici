# frozen_string_literal: true

require "rails_helper"

RSpec.describe "/users/auth/:provider", type: :system do
  describe "/users/auth/strava/callback" do
    subject(:do_request) { get user_strava_omniauth_callback_path }

    let(:callback_params) do
      {
        credentials: {
          token: "token"
        },
        info: {
          name: "Athlete Name"
        },
        provider: "strava",
        uid: "1234"
      }
    end

    before do
      config = OmniAuth.config
      allow(config).to receive(:test_mode).and_return true
      allow(config.mock_auth)
        .to receive(:[]).with(:strava).and_return(OmniAuth::AuthHash.new(callback_params))
    end

    context "when user does not exists" do
      it "creates user" do
        expect { do_request }.to(change(User::Record, :count).by(1))
      end

      it "redirects to root page" do
        do_request
        expect(response).to redirect_to "/"
      end
    end

    context "when user exists" do
      before { create(:user, email: "user@company.com", oauth_provider: "strava", oauth_uid: "1234") }

      it "does not create user" do
        expect { do_request }.not_to(change(User::Record, :count))
      end

      it "redirects to root page" do
        do_request
        expect(response).to redirect_to "/"
      end
    end
  end
end
