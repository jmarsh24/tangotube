# frozen_string_literal: true

require "rails/generators"
require "#{Gem::Specification.find_by_name("stimulus-rails").full_gem_path}/lib/generators/stimulus/stimulus_generator.rb"

class StimulusGenerator
  source_root "#{Gem::Specification.find_by_name("stimulus-rails").full_gem_path}/lib/generators/stimulus/templates"

  def copy_view_files
    @attribute = stimulus_attribute_value(controller_name)
    template "controller.js", "app/javascript/controllers/#{controller_name}_controller#{ext}"
    rails_command "stimulus:manifest:update" unless Rails.root.join("config/importmap.rb").exist?
  end

  private

  def ext
    (File.extname(Dir.glob("app/javascript/controllers/application*")[0]) == ".ts") ? ".ts" : ".js"
  end
end
