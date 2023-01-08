# frozen_string_literal: true

disabled_locales = ENV["DISABLED_LOCALES"].to_s.split(",").map(&:downcase).map(&:to_sym)
I18n.enforce_available_locales = true
I18n.available_locales = [:en] - disabled_locales
I18n.default_locale = I18n.available_locales.first

Rails.application.configure do
  config.i18n.fallbacks = [:en]
end
