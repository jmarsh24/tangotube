# frozen_string_literal: true

class WebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token

  def facebook_user_deletion
    signed_request = params["signed_request"]
    data = parse_fb_signed_request(signed_request)

    user = User.find_by(uid: data["user_id"])
    user.destroy!

    data = {url: "https://#{Config.base_uri!}/deletion_status?id=del_#{user.id}", confirmation_code: "del_#{user.id}"}
    respond_to do |format|
      format.json { render json: data }
    end
  end

  # @route GET /webhooks/youtube (webhooks_youtube)
  # @route POST /webhooks/youtube (webhooks_youtube)
  def youtube
    if params["hub.challenge"]
      render plain: params["hub.challenge"]
    else
      youtube_event = YoutubeEvent.create!(data: Hash.from_xml(request.body.read).as_json)
      YoutubeEventHandlerJob.perform_later(youtube_event.id)
      render json: {status: "ok"}
    end
  end

  # @route POST /webhooks/patreon (webhooks_patreon)
  def patreon
    patreon_event = PatreonEvent.create!(
      event_type: request.headers["X-Patreon-Event"],
      data: JSON.parse(request.body.read)
    )
    PatreonEventHandlerJob.perform_later(patreon_event)
    head :ok
  end

  private

  def parse_fb_signed_request(signed_request)
    encoded_sig, payload = signed_request.split(".", 2)
    secret = Config.facebook_app_secret!

    decoded_sig = Base64.urlsafe_decode64(encoded_sig)
    data = JSON.load(Base64.urlsafe_decode64(payload))

    expected_sig = OpenSSL::HMAC.digest("SHA256", secret, payload)

    if decoded_sig != expected_sig
      puts "Bad Signed JSON signature!"
      return nil
    end
    data
  end
end
