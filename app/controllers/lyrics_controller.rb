# frozen_string_literal: true

class LyricsController < ApplicationController
  def show
    @song = Song.find_by(slug: params[:song_id])
  end
end
