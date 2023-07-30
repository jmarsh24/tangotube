# frozen_string_literal: true

class WebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token

  # @route GET /webhooks/youtube (webhooks#youtube)
  def youtube
    if params["hub.challenge"]
      render plain: params["hub.challenge"]
    else
      youtube_event = YoutubeEvent.create!(data: Hash.from_xml(request.body.read).as_json)
      YoutubeEventHandlerJob.perform_later(youtube_event.id)
      render json: {status: "ok"}
    end
  end

  # @route POST /webhooks/patreon (webhooks#patreon)
  def patreon
    patreon_event = PatreonEvent.create!(
      event_type: request.headers["X-Patreon-Event"],
      data: JSON.parse(request.body.read)
    )
    PatreonEventHandlerJob.perform_later(patreon_event)
    head :ok
  end
end
