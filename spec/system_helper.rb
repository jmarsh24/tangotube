# frozen_string_literal: true

require "rails_helper"
require "rack_session_access/capybara"

# Rails.application.routes.default_url_options[:locale] = :en
Capybara::Screenshot::Diff.enabled = false
Capybara::Screenshot.enabled = Config.screenshots?

RSpec.configure do |config|
  config.before(:each, type: :system) do
    driven_by Capybara.javascript_driver
  end

  # rspec-retry
  config.verbose_retry = true
  config.display_try_failure_messages = true
  config.default_sleep_interval = ENV.fetch("RSPEC_RETRY_SLEEP_INTERVAL", 0).to_i
  config.retry_callback = proc do
    Capybara.reset!
  end
end
