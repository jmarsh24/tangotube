# frozen_string_literal: true

class LyricsController < ApplicationController
  # @route GET /songs/:song_id/lyrics (song_lyrics)
  def show
    @song = Song.find_by(slug: params[:song_id])
  end
end
