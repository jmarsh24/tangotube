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
  config.define_cassette_placeholder("<SPOTIFY_CLIENT_ID>") { Rails.application.credentials.dig(:acr_cloud, :client_id) }
  config.define_cassette_placeholder("<SPOTIFY_SECRET_KEY>") { Rails.application.credentials.dig(:spotify, :secret_key) }
  config.define_cassette_placeholder("<ACRCLOUD_ACCESS_KEY>") { Rails.application.credentials.dig(:acr_cloud, :access_key) }
  config.define_cassette_placeholder("<ACRCLOUD_SECRET_KEY>") { Rails.application.credentials.dig(:acr_cloud, :secret_key) }
  config.define_cassette_placeholder("<YOUTUBE_API_KEY>") { Rails.application.credentials.dig(:youtube, :api_key) }
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
