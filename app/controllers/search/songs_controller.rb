# frozen_string_literal: true

class Search::SongsController < ApplicationController
  # @route GET /search/songs (search_songs)
  def index
    @songs =
      if params[:query].present?
        Song.search(params[:query]).preload(orchestra: {profile_image_attachment: :blob}).limit(100).load_async
      else
        Song.all.preload(orchestra: {profile_image_attachment: :blob}).limit(100).most_popular.load_async
      end
  end
end
