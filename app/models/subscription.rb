# frozen_string_literal: true

class Subscription < ApplicationRecord
  SUBSCRIBE_URL = "https://pubsubhubbub.appspot.com/subscribe"
  TOPIC_URL = "https://www.youtube.com/xml/feeds/videos.xml?channel_id="
  CALLBACK_URL = "https://#{Config.base_uri!}/webhooks".freeze

  class << self
    def to_youtube_channel(channel_id)
      Faraday.post SUBSCRIBE_URL,
        {"hub.mode" => "subscribe",
         "hub.callback" => CALLBACK_URL,
         "hub.lease_seconds" => 31536000,
         "hub.topic" => TOPIC_URL + channel_id,
         "hub.verify" => "synchronous"}
    end
  end
end
