# frozen_string_literal: true

Sentry.init do |config|
  sentry_environment = Config.sentry_environment || Rails.env
  next unless Rails.env.production?

  config.dsn = "https://a50690fbdd8546f49dd1153095fce6cd@o4504470653173760.ingest.sentry.io/4504470654681088"
  config.breadcrumbs_logger = [:active_support_logger, :http_logger]
  config.environment = sentry_environment
  config.enabled_environments = [sentry_environment].filter_map(&:presence).excluding("development", "test")
end
