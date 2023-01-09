# frozen_string_literal: true

class YoutubeMusicMatchJob < ApplicationJob
  queue_as :low_priority
  sidekiq_options queue: :default, retry: false

  def perform(youtube_id)
    Video::MusicRecognition::Youtube.fetch(youtube_id)
  end
end
