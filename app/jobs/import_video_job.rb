# frozen_string_literal: true

class ImportVideoJob < ApplicationJob
  queue_as :import

  def perform(youtube_slug, use_scraper: true, use_music_recognizer: true)
    Import::Importer.new.import(youtube_slug, use_scraper:, use_music_recognizer:)
  end
end
