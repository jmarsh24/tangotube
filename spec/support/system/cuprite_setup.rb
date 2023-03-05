# frozen_string_literal: true

require "capybara/cuprite"

# Then, we need to register our driver to be able to use it later
# with #driven_by method.
Capybara.register_driver(:chrome) do |app|
  Capybara::Cuprite::Driver.new(
    app,
    window_size: [1280, 1400],
    # See additional options for Dockerized environment in the respective section of this article
    browser_options: {},
    # Increase Chrome startup wait time (required for stable CI builds)
    process_timeout: 10,
    # Usually, especially when using Selenium, developers tend to increase the max wait time.
    # With Cuprite, there is no need for that.
    # We use a Capybara default value here explicitly.
    default_max_wait_time: 2,
    # Enable debugging capabilities
    inspector: true,
    js_errors: true,
    # Allow running Chrome in a headful mode by setting HEADLESS env
    # var to a falsey value
    headless: Config.headless?
  )
end

# Configure Capybara to use :cuprite driver by default
Capybara.default_driver = Capybara.javascript_driver = :chrome
Capybara.enable_aria_label = true
# Normalize whitespaces when using `has_text?` and similar matchers,
# i.e., ignore newlines, trailing spaces, etc.
# That makes tests less dependent on slightly UI changes.
Capybara.default_normalize_ws = true
Capybara.disable_animation = true
