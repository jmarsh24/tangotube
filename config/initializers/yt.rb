# frozen_string_literal: true

if Config.youtube_api_key?
  Yt.configure do |config|
    config.api_key = Config.youtube_api_key
    config.log_level = :debug
  end
end
