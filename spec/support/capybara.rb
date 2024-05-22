# frozen_string_literal: true

require "capybara/cuprite"
require "capybara/rspec"
require "capybara/rails"
require "capybara-screenshot/rspec"

# Use a hostname that could be resolved in the internal Docker network
Capybara.app_host = "http://#{ENV.fetch('APP_HOST', `hostname`.strip&.downcase || '0.0.0.0')}"
# Make server accessible from the outside world
Capybara.server_host = "0.0.0.0"
Capybara.default_max_wait_time = 2
Capybara.default_normalize_ws = true
Capybara.disable_animation = true
Capybara.save_path = ENV.fetch("CAPYBARA_ARTIFACTS", "./tmp/capybara")
Capybara.default_driver = :rack_test
Capybara.javascript_driver = :cuprite

# Parse URL
# NOTE: REMOTE_CHROME_HOST should be added to Webmock/VCR allowlist if you use any of those.
REMOTE_CHROME_URL = ENV.fetch("CHROME_URL", nil)
REMOTE_CHROME_HOST, REMOTE_CHROME_PORT =
  if REMOTE_CHROME_URL
    URI.parse(REMOTE_CHROME_URL).then do |uri|
      [uri.host, uri.port]
    end
  end

# Check whether the remote chrome is running.
remote_chrome =
  begin
    if REMOTE_CHROME_URL.nil?
      false
    else
      Socket.tcp(REMOTE_CHROME_HOST, REMOTE_CHROME_PORT, connect_timeout: 1).close
      true
    end
  rescue Errno::ECONNREFUSED, Errno::EHOSTUNREACH, SocketError
    false
  end

remote_options = remote_chrome ? { url: REMOTE_CHROME_URL } : {}

options = {
  js_errors: true,
  headless: %w[0 false].exclude?(ENV.fetch("HEADLESS", nil)),
  slowmo: ENV["SLOWMO"]&.to_f,
  process_timeout: 15,
  timeout: 10,
  inspector: true,
  browser_options: ENV["DOCKER"] ? { "no-sandbox" => nil } : {}
}.merge(remote_options)

RSpec.configure do |config|
  config.before(:each, type: :system) do
    driven_by :rack_test # rack_test by default, for performance
  end

  config.before(:each, js: true, type: :system) do
    driven_by(Capybara.javascript_driver, screen_size: [1440, 810], options:)
  end

  config.prepend_before(:each, type: :system) do
    driven_by(Capybara.javascript_driver, screen_size: [1440, 810], options:)
  end

  config.filter_gems_from_backtrace("capybara", "cuprite", "ferrum")
end

module CupriteHelpers
  # Drop #pause anywhere in a test to stop the execution.
  # Useful when you want to checkout the contents of a web page in the middle of a test
  # running in a headful mode.
  def pause
    page.driver.pause
  end

  # Drop #debug anywhere in a test to open a Chrome inspector and pause the execution
  def debug(binding = nil)
    $stdout.puts "🔎 Open Chrome inspector at http://localhost:3333"
    return binding.break if binding

    page.driver.pause
  end
end

RSpec.configure do |config|
  config.include CupriteHelpers, type: :system
end
