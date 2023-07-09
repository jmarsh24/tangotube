# frozen_string_literal: true

class UpdateVideoJob < ApplicationJob
  queue_as :low_priority

  def perform(video, use_scraper: false, use_music_recognizer: false)
    ExternalVideoImport::Importer.new.update(video, use_scraper:, use_music_recognizer:)
  end
end
