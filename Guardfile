# frozen_string_literal: true

clearing :on
guard :rspec, cmd: "bin/rspec" do
  require "guard/rspec/dsl"
  dsl = Guard::RSpec::Dsl.new(self)
  # RSpec files
  rspec = dsl.rspec
  watch(rspec.spec_files)

  # Ruby files
  ruby = dsl.ruby
  dsl.watch_spec_files_for(ruby.lib_files)

  # Rails files
  rails = dsl.rails
  dsl.watch_spec_files_for(rails.app_files)
  dsl.watch_spec_files_for(rails.views)

  # Factory Bot
  watch(%r{^spec/factories/.+\.rb}) { "spec/features/factory_bot_spec.rb" }

  watch(%r{^app/controllers/(.+)_(controller)\.rb}) { |m| "spec/requests/#{m[1]}_spec.rb" }
  watch(%r{^app/controllers/(.+)s_(controller)\.rb}) { |m| "spec/system/#{m[1]}_spec.rb" }
  watch(%r{^app/views/(.+)s/.+.html.slim}) { |m| "spec/system/#{m[1]}_spec.rb" }
  watch(%r{^app/printers/(.+)_(printer)\.rb}) { |m| "spec/requests/#{m[1]}_spec.rb" }
end
