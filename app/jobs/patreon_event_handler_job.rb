# frozen_string_literal: true

class PatreonEventHandlerJob < ApplicationJob
  queue_as :default

  def perform(patreon_event)
    patreon_id = patreon_event.data.dig("data", "relationships", "patron", "data", "id")
    user = User.find_by(patreon_id:)

    if user
      case patreon_event.event_type
      when "pledges:create", "pledges:update"
        user.update!(supporter: true)
      when "pledges:delete"
        user.update!(supporter: false)
      end
    else
      Rails.logger.info "PatreonEventHandlerJob: User not found for Patreon ID #{patreon_id}"
    end
  end
end
