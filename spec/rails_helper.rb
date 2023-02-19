# frozen_string_literal: true

require "devise"
require "spec_helper"
ENV["RAILS_ENV"] ||= "test"
require File.expand_path("../config/environment", __dir__)
abort("The Rails environment is running in production mode!") if Rails.env.production?
require "rspec/rails"
require "webmock/rspec"
require_relative Rails.root.join("config/initializers/storage")
Dir[Rails.root.join("spec/support/**/*.rb")].sort.each { |f| require f }

begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  puts e.to_s.strip
  exit 1
end

VCR.configure do |config|
  config.cassette_library_dir = "#{::Rails.root}/spec/cassettes"
  config.hook_into :webmock
  config.ignore_localhost = true
  config.allow_http_connections_when_no_cassette = true
  config.configure_rspec_metadata!
  config.define_cassette_placeholder("<YOUTUBE_API_KEY>") { Config.youtube_api_key! }
  config.define_cassette_placeholder("DEEPL_AUTH_KEY") { Config.deepl_auth_key! }
  config.define_cassette_placeholder("<AVO_LICENSE_KEY>") { Config.avo_license_key! }
  config.define_cassette_placeholder("<GIPHY_API_KEY>") { Config.giphy_api_key! }
  config.define_cassette_placeholder("<ACRCLOUD_ACCESS_KEY>") { Config.acr_cloud_access_key! }
  config.define_cassette_placeholder("<ACRCLOUD_SECRET_KEY>") { Config.acr_cloud_secret_key! }
  config.define_cassette_placeholder("<SPOTIFY_CLIENT_ID>") { Config.spotify_client_id! }
  config.define_cassette_placeholder("<SPOTIFY_SECRET_KEY>") { Config.spotify_secret_key! }
  config.define_cassette_placeholder("<SENDGRID_USERNAME>") { Config.sendgrid_username! }
  config.define_cassette_placeholder("<SENDGRID_PASSWORD>") { Config.sendgrid_password! }
  config.define_cassette_placeholder("<SENDGRID_API_KEY>") { Config.sendgrid_api_key! }
  config.define_cassette_placeholder("<AWS_ACCESS_KEY_ID>") { Config.aws_access_key_id! }
  config.define_cassette_placeholder("<AWS_SECRET_ACCESS_KEY>") { Config.aws_secret_access_key! }
  config.define_cassette_placeholder("<GITHUB_KEY>") { Config.github_key! }
  config.define_cassette_placeholder("<GITHUB_SECRET>") { Config.github_secret! }
  config.define_cassette_placeholder("<GOOGLE_CLIENT_ID>") { Config.google_client_id! }
  config.define_cassette_placeholder("<GOOGLE_CLIENT_SECRET>") { Config.google_client_secret! }
  config.define_cassette_placeholder("<FACEBOOK_APP_ID>") { Config.facebook_app_id! }
  config.define_cassette_placeholder("<FACEBOOK_APP_SECRET>") { Config.facebook_app_secret! }
end

RSpec.configure do |config|
  config.include ActiveSupport::Testing::TimeHelpers
  config.include ActiveJob::TestHelper
  config.include Devise::Test::ControllerHelpers, type: :controller
  config.include Devise::Test::IntegrationHelpers, type: :system
  config.include Warden::Test::Helpers

  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!

  config.before(:suite) do
    WebMock.disable_net_connect!(allow_localhost: true)
  end

  config.around do |example|
    example.run
    WebMock.reset!
    Rails.cache.clear
  end
end
