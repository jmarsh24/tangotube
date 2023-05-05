# frozen_string_literal: true
if Config.deepl_auth_key?
  DeepL.configure do |config|
    config.auth_key = Config.deepl_auth_key!
    config.host = "https://api-free.deepl.com" # Default value is 'https://api.deepl.com'
    config.version = "v2" # Default value is 'v2'
  end
end