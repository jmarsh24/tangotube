# frozen_string_literal: true

require 'rails/rack/logger'

class SilentLoggerMiddleware < Rails::Rack::Logger
  def call(env)
    if env['REQUEST_METHOD'] == 'GET' && env['PATH_INFO'] == '/up'
      Rails.logger.silence { super }
    else
      super
    end
  end
end
