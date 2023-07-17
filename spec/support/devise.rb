# frozen_string_literal: true

require_relative "controller_macros" # or require_relative './controller_macros' if write in `spec/support/devise.rb`

RSpec.configure do |config|
  config.include Devise::TestHelpers, type: :controller
  config.extend ControllerMacros, type: :controller
  config.responder.error_status = :unprocessable_entity
  config.responder.redirect_status = :see_other
end
