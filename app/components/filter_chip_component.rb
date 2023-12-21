# frozen_string_literal: true

class FilterChipComponent < ViewComponent::Base
  def initialize(name:, link_path:, active:, highlighted:, closeable:)
    @name = name
    @link_path = link_path
    @active = active
    @highlighted = highlighted
    @closeable = closeable
  end
end
