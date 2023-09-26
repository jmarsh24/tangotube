# frozen_string_literal: true

source "https://rubygems.org"

ruby "3.2.2"

gem "rails", "7.0.6"
gem "rack", "2.2.7"
gem "puma"

# databases
gem "pg"
gem "redis"

gem "oj"
gem "bootsnap", require: false

# app specific gems...................................................................
gem "acts-as-taggable-on"
gem "acts_as_list"
gem "activestorage"
gem "amazing_print"
gem "avo"
gem "bcrypt"
gem "friendly_id"
gem "groupdate"
gem "countries", require: "countries/global"
gem "chartkick"
gem "counter_culture"
gem "dalli"
gem "devise"
gem "document_serializable"
gem "dotenv-rails"
gem "hashie"
gem "httparty"
gem "image_processing"
gem "omniauth-facebook"
gem "omniauth-google-oauth2"
gem "omniauth-rails_csrf_protection"
gem "kaminari"
gem "pundit"
gem "rails-i18n"
gem "safety_mailer"
gem "shimmer"
gem "slim-rails"
gem "sidekiq"
gem "sidekiq-scheduler"
gem "sitemap_generator"
gem "streamio-ffmpeg"
gem "translate_client"
gem "net-ssh"
gem "yael"
gem "store_model"
gem "down"
gem "capybara"
gem "cuprite"
gem "activerecord-postgres_enum"
gem "ransack"
gem "scenic"
gem "patreon"
gem "strip_attributes"
gem "goldiloader"
gem "browser"

# Assets
gem "vite_rails"
gem "propshaft"
gem "stimulus-rails"
gem "turbo-rails"
gem "serviceworker-rails"
gem "thumbhash"

# External Services
gem "aws-sdk-s3"
gem "deepl-rb", require: "deepl"
gem "yt"
gem "newrelic_rpm"
gem "barnes" # enables detailed metrics within heroku
gem "sentry-ruby"
gem "sentry-rails"

group :development, :test do
  gem "rspec-rails"
  gem "standard"
  gem "debug"
  gem "i18n-tasks"
  gem "chusaku", require: false
  gem "capybara-screenshot-diff"
end

group :test do
  gem "vcr"
  gem "webmock", require: false
  gem "rack_session_access"
  gem "rspec-retry"
end

group :development do
  gem "listen"
  gem "web-console"
  gem "annotate"
  gem "rb-fsevent"
  gem "letter_opener"
  gem "guard"
  gem "guard-rspec"
  gem "ruby-lsp", require: false
  gem "rubocop-rails"
  gem "rubocop-performance"
  gem "rubocop-rspec"
  gem "rubocop-rake"
  gem "mrsk"
end
