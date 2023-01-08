# frozen_string_literal: true

require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

Config = Shimmer::Config.instance.freeze

module TangoTube
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0
    config.exceptions_app = routes
    config.time_zone = "Berlin"
    config.require_master_key = true

    config.autoload_paths << "#{root}/app/avo/actions"
    config.autoload_paths << "#{root}/app/policies/concerns"

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
    config.active_storage.variant_processor = :mini_magick

    config.assets.paths << Rails.root.join("node_modules")
    ActiveRecord::Tasks::DatabaseTasks.fixtures_path = Rails.root.join("spec/fixtures")
  end
end
