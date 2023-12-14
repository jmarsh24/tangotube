# frozen_string_literal: true

require_relative "boot"

require "rails"

# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_mailbox/engine"
require "action_text/engine"
require "action_view/railtie"
require "action_cable/engine"
# require "rails/test_unit/railtie"

Bundler.require(*Rails.groups)

Config = Shimmer::Config.instance.freeze

module TangoTube
  class Application < Rails::Application
    config.load_defaults 7.0
    config.exceptions_app = routes
    config.time_zone = "Berlin"

    config.autoload_paths << "#{root}/app/avo/actions"
    config.autoload_paths << "#{root}/app/policies/concerns"
    config.autoload_paths << "#{root}/app/presenters"
    config.autoload_paths += Dir[Rails.root.join("app/models/types/*.rb")].each { |file| require file }

    config.middleware.use Shimmer::CloudflareProxy

    host = if ENV["HOST"].present?
      ENV["HOST"]
    elsif ENV["HEROKU_APP_NAME"].present?
      "#{ENV["HEROKU_APP_NAME"]}.herokuapp.com"
    else
      "localhost:3000"
    end

    protocol = host.include?("localhost") ? "http" : "https"
    Rails.application.routes.default_url_options[:host] = host
    config.action_mailer.default_url_options({host:})
    config.action_mailer.asset_host = "#{protocol}://#{host}"
    config.active_storage.variant_processor = :vips
    # config.active_storage.resolve_model_to_route = :rails_storage_proxy
    # config.active_storage.web_image_content_types = ["image/jpeg", "image/png", "image/webp", "image/jpg", "image/avif"]

    ActiveRecord::Tasks::DatabaseTasks.fixtures_path = Rails.root.join("spec/fixtures")
  end
end
