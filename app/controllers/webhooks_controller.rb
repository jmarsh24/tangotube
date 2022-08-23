class WebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    youtube_event = YoutubeEvent.create!(
      data: Hash.from_xml(request.body.read).as_json,
    )
    YoutubeEventHandlerJob.perform_async(youtube_event.id)
    render json: { status: "ok"}
  end

  def index
    if params["hub.challenge"]
      render plain: params["hub.challenge"]
    end
  end
end
