# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Fms Dashboard", js: true do
  before { visit(dashboard_index_path) }

  it "displays fms dashboard title" do
    expect(page).to have_current_path(dashboard_index_path)
  end
end
