# frozen_string_literal: true

module CupriteHelper
  def pause
    page.driver.pause
  end

  def debug
    page.driver.debug(binding)
  end

  def screenshot(name)
    return unless Config.screenshots?

    width = page.current_window.size[0]
    height = page.current_window.size[1]
    super("#{name}--desktop")
    page.current_window.resize_to(375, height)
    super("#{name}--mobile")
    page.current_window.resize_to(744, height)
    super("#{name}--tablet")
    page.current_window.resize_to(width, height)
  end
end

RSpec.configure do |config|
  config.include Capybara::Screenshot::Diff::TestMethods, type: :system
  config.include CupriteHelper, type: :system
end
