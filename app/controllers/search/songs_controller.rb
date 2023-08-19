# frozen_string_literal: true

class Search::SongsController < ApplicationController
  # @route GET /search/songs (search_songs)
  def index
    @songs =
      if params[:query].present?
        Song.search(params[:query]).preload(:orchestra).limit(100)
      else
        Song.all.limit(100).most_popular
      end
  end
end
