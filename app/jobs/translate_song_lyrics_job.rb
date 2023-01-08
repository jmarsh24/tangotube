# frozen_string_literal: true

class TranslateSongLyricsJob < ApplicationJob
  queue_as :low_priority

  def perform(song_id)
    song = Song.find(song_id)
    song.translate_to_english
  end
end
