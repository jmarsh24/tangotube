# frozen_string_literal: true

class UpdateWithMusicRecognizerVideoJob < ApplicationJob
  queue_as :music_recognizer

  def perform(video)
    Import::Importer.new.update(video, use_music_recognizer: true)
  end
end
