# frozen_string_literal: true

class ImportVideoJob < ApplicationJob
  def perform(youtube_slug, use_scraper: true, use_music_recognizer: true)
    self.class.queue_as use_music_recognizer ? :music_recognizer_queue : :update

    Import::Importer.new.import(youtube_slug, use_scraper:, use_music_recognizer:)
  end
end
