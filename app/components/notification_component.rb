# frozen_string_literal: true

class NotificationComponent < ViewComponent::Base
  def initialize(flash:)
    @flash = flash
  end

  def notifications
    @flash.map do |type, message|
      {type:, message:}
    end
  end
end
