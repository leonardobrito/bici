# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Fms Dashboard", js: true, type: :feature do
  it "displays fms dashboard title" do
    visit(dashboard_index)
    page.save_screenshot("screenshot.png")
    expect(page).to have_current_path(dashboard_index_path)
  end
end
