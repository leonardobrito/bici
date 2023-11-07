# frozen_string_literal: true

FactoryBot.define do
  factory :user, class: "::User::Record" do
    sequence(:email) { |n| "user#{n}@email.com" }
    password { "password" }
  end
end
