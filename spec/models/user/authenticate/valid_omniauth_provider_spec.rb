# frozen_string_literal: true

require "rails_helper"

RSpec.describe User::Authenticate::ValidOmniauthProvider do
  subject(:validate) { described_class.new(oauth_provider: provider).call }

  let(:provider) { "strava" }

  context "when oauth_provider is strava" do
    it {
      expect(validate).to be_truthy
    }
  end

  context "when oauth_provider is not supported" do
    let(:provider) { "facebook" }

    it {
      expect(validate).to be_falsy
    }
  end
end
