Yt.configure do |config|
  config.api_key = Rails.application.credentials.youtube[:api_key]
  config.log_level = :debug
end
