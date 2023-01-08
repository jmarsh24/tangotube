# frozen_string_literal: true

Yt.configure do |config|
  config.api_key = Rails.application.credentials.dig(:youtube, :api_key)
  config.log_level = :debug
end
