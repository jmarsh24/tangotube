# frozen_string_literal: true

source "https://rubygems.org"
ruby File.read(File.join(__dir__, ".ruby-version")).strip

gem "rails", "7.1"
gem "puma"
gem "rack"

# databases
gem "pg"

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
gem "solid_cache"
gem "good_job"
gem "kamal"
gem "pghero"
gem "strong_migrations"
gem "pg_query", ">= 2"

# Assets
gem "vite_rails"
gem "propshaft"
gem "stimulus-rails"
gem "turbo-rails"
gem "serviceworker-rails"
gem "thumbhash"
gem "ruby-lsp-rails"

# External Services
gem "aws-sdk-s3"
gem "deepl-rb", require: "deepl"
gem "yt"
gem "newrelic_rpm"
gem "sentry-ruby"
gem "sentry-rails"

group :development, :test do
  gem "rspec-rails"
  gem "standard"
  gem "debug"
  gem "i18n-tasks"
  gem "chusaku", require: false
  gem "capybara-screenshot-diff"
  gem "guard"
  gem "guard-rspec"
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
  gem "rubocop-rails"
  gem "rubocop-performance"
  gem "rubocop-rspec"
  gem "rubocop-rake"
  gem "rack-mini-profiler"
end
