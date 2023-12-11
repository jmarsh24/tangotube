# frozen_string_literal: true

class ImportVideoJob < ApplicationJob
  queue_as :music_recognizer

  def perform(youtube_slug)
    Import::Importer.new.import(youtube_slug, use_music_recognizer: true)
  end
end
