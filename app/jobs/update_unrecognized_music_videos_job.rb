# frozen_string_literal: true

class UpdateUnrecognizedMusicVideosJob < ApplicationJob
  queue_as :default

  def perform
    Video.music_unrecognized.limit(10_000).find_each do |video|
      UpdateVideoJob.perform_later(video, use_music_recognizer: true)
    end
  end
end
