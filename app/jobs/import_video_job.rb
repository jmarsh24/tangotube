# frozen_string_literal: true

class ImportVideoJob < ApplicationJob
  queue_as :import

  def perform(youtube_slug, use_scraper: false, use_music_recognizer: true, use_chat_gpt: true)
    Import::Importer.new.import(youtube_slug, use_scraper:, use_music_recognizer:, use_chat_gpt:)
  end
end
