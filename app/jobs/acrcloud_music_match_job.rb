# frozen_string_literal: true

class AcrcloudMusicMatchJob < ApplicationJob
  queue_as :low_priority
  sidekiq_options queue: :default, retry: 3

  def perform(*_args)
    Video::MusicRecognition::AcrCloud.fetch(@youtube_id)
  end
end
