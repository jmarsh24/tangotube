# frozen_string_literal: true

class AcrMusicMatchJob < ApplicationJob
  queue_as :low_priority
  sidekiq_options queue: :default, retry: true

  def perform(youtube_id)
    Video::MusicRecognition::AcrCloud.fetch(youtube_id)
  end
end
