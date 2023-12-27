# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Fms Dashboard", js: true do
  it "displays fms dashboard title" do
    visit(dashboard_index)
    expect(page).to have_current_path(dashboard_index_path)
  end
end
