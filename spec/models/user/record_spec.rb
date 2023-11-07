# frozen_string_literal: true

require "rails_helper"

RSpec.describe User::Record do
  subject { build(:user) }

  it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
end
