# frozen_string_literal: true

class WebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token

  # @route GET /webhooks (webhooks)
  def index
    if params["hub.challenge"]
      render plain: params["hub.challenge"]
    end
  end

  # @route POST /webhooks (webhooks)
  def create
    youtube_event = YoutubeEvent.create!(
      data: Hash.from_xml(request.body.read).as_json
    )
    YoutubeEventHandlerJob.perform_later(youtube_event.id)
    render json: {status: "ok"}
  end
end
