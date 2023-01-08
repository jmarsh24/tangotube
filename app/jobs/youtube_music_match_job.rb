# frozen_string_literal: true

class YoutubeMusicMatchJob < ApplicationJob
  queue_as :low_priority
  sidekiq_options queue: :default, retry: false

  def perform(youtube_id)
    Video::MusicRecognition::Youtube.from_video(youtube_id)
  end
end
