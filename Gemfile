source "https://rubygems.org"

ruby "3.0.3"

# gems that ship with rails...........................................................
gem "bootsnap", require: false
gem "spring"
gem "rails", "~> 7.0.2.2"
gem "redis"
gem "puma"
gem "pg"
gem "barnes", "~> 0.0.9"

# app specific gems...................................................................
gem "acts_as_votable"
gem "ahoy_matey"
gem "aws-sdk-s3", require: false
gem "deepl-rb", require: 'deepl'
gem "devise"
gem "faraday"
gem "font-awesome-rails"
gem "hashie"
gem "hotwire-rails"
gem "jsbundling-rails"
gem "nokogiri"
gem 'omniauth-facebook'
gem 'omniauth-google-oauth2'
gem "omniauth-rails_csrf_protection"
gem "prettier"
gem "pg_search"
gem "rails_autolink"
gem "rspotify"
gem "sassc-rails"
gem "scenic"
gem "sidekiq"
gem "spring-watcher-listen",  "2.0.1"
gem "stimulus-rails"
gem "streamio-ffmpeg"
gem "turbo-rails"
gem "tzinfo-data", platforms: %i[ mingw mswin x64_mingw jruby ]
gem "yt"

group :development, :test do
  gem "amazing_print"
  gem "dotenv-rails"
  gem "factory_bot_rails"
  gem "faker"
  gem "rspec-rails"
  gem "byebug"
  gem 'webdrivers'
end

group :development do
  gem "listen", "~> 3.2"
  gem "rack-mini-profiler"
  gem "rubocop"
  gem "rubocop-rails"
  gem "rubocop-rspec"
  gem "solargraph"
  gem "web-console", "4.0.2"
end

group :test do
  gem "capybara"
  gem 'capybara-screenshot'
  gem "selenium-webdriver"
  gem "shoulda-matchers"
  gem "simplecov", require: false
  gem 'rspec-sidekiq'
  gem "vcr"
  gem "webmock"
end
