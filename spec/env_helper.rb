# frozen_string_literal: true

module EnvHelper
  def with_modified_env(options = {}, &block)
    options.transform_values!(&:to_s)
    ClimateControl.modify(options, &block)
  end
end

RSpec.configure do |config|
  config.include EnvHelper
end
