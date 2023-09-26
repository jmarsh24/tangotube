# frozen_string_literal: true

class SongsController < ApplicationController
  def top_songs
    @songs = Song.joins(:orchestra).most_popular.limit(24)
  end
end
