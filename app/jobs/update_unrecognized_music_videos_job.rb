# frozen_string_literal: true

class UpdateUnrecognizedMusicVideosJob < ApplicationJob
  queue_as :update

  def perform
    Video.music_unrecognized.limit(10_000).not_hidden.from_active_channels.find_each do |video|
      UpdateWithMusicRecognizerVideoJob.perform_later(video)
    end
  end
end
