# frozen_string_literal: true

class UpdateVideoJob < ApplicationJob
  queue_as :update

  def perform(video)
    Import::Importer.new.update(video, use_music_recognizer: false)
  end
end
