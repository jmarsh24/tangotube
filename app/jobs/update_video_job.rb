# frozen_string_literal: true

class UpdateVideoJob < ApplicationJob
  def perform(video, use_scraper: false, use_music_recognizer: false)
    self.class.queue_as use_music_recognizer ? :music_recognizer_queue : :update

    Import::Importer.new.update(video, use_scraper:, use_music_recognizer:)
  end
end
