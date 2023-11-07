# frozen_string_literal: true

require "rails_helper"

RSpec.describe User::Repository do
  subject(:repository) { described_class }

  describe "#find_or_create_by_oauth" do
    let(:info) { { name: "Athlete Name" } }
    let(:provider) { "strava" }
    let(:uid) { "1234" }

    let(:oauth_data) { OmniAuth::AuthHash.new(info:, provider:, uid:) }

    it "finds or create a user by oauth" do
      user = repository.find_or_create_by_oauth(oauth: oauth_data)
      expect(user).to be_an_instance_of(User::Record)
    end
  end

  describe "#find_user_by_oauth_uid" do
    let(:uid) { "1234" }

    before { create(:user, oauth_uid: uid) }

    it "returns expected user" do
      user = repository.find_user_by_oauth_uid(oauth_uid: uid)
      expect(user.oauth_uid).to eq(uid)
    end
  end
end
