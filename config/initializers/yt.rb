# frozen_string_literal: true

Yt.configure do |config|
  config.api_key = Rails.env.test? ? "YOUTUBE_API_KEY" : Config.youtube_api_key!
  config.log_level = :debug
end
