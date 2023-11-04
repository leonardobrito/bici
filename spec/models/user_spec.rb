# frozen_string_literal: true

require "rails_helper"

RSpec.describe User do
  subject { build(:user) }

  it { is_expected.to validate_uniqueness_of(:email).case_insensitive }

  describe "#from_omniauth" do
    subject(:user) { described_class.first }

    let(:uid) { "1234" }
    let(:info) { { name: "Athlete", email: nil } }
    let(:provider) { "strava" }
    let(:oauth_provider_data) do
      OmniAuth::AuthHash.new({ provider:, uid:, info: })
    end

    before { described_class.from_omniauth(oauth_provider_data) }

    context "when oauth_provider is strava" do
      it "match oauth_uid" do
        expect(user.oauth_uid).to eq(uid)
      end

      it "match oauth_provider" do
        expect(user.oauth_provider).to eq(provider)
      end
    end

    context "when oauth_provider is not supported" do
      let(:provider) { "facebook" }

      it "not persist the user" do
        expect(user).to be_nil
      end
    end
  end
end
