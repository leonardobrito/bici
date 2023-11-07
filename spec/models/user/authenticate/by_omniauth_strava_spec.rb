# frozen_string_literal: true

require "rails_helper"

RSpec.describe User::Authenticate::ByOmniauthStrava do
  subject(:authenticate) { described_class.new(oauth: oauth_data).call }

  let(:info) { { name: "Athlete Name" } }
  let(:provider) { "strava" }
  let(:uid) { "1234" }

  let(:oauth_data) { OmniAuth::AuthHash.new(info:, provider:, uid:) }

  it "creates a new user" do
    expect { authenticate }.to change(User::Record, :count).by(1)
  end

  it "persisted to be truthy" do
    persisted, _user = authenticate
    expect(persisted).to be_truthy
  end

  it "name to be equal info.name" do
    _persisted, user = authenticate
    expect(user.name).to eq(oauth_data.info.name)
  end

  context "when user already exists" do
    before { create(:user, oauth_provider: provider, oauth_uid: uid) }

    it "does not persist a new user" do
      expect { authenticate }.not_to change(User::Record, :count)
    end
  end
end
