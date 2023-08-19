# frozen_string_literal: true

class Search::SongsController < ApplicationController
  # @route GET /search/songs (search_songs)
  def index
    @recent_searches = current_user.recent_searches.includes(:searchable).unique_by_searchable.limit(10) if current_user
  end
end
