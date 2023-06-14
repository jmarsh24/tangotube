# frozen_string_literal: true

class UpdateUnrecognizedMusicVideosJob < ApplicationJob
  queue_as :default

  def perform
    Video.unrecognized_music.limit(10_000).find_each do |video|
      UpdateVideoJob.perform_later(video, use_scraper: false)
    end
  end
end
