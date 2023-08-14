# frozen_string_literal: true

class SearchesController < ApplicationController
  # @route GET /search/new (new_search)
  def new
    @categories = search_categories_options
    @recent_searches = current_user.recent_searches.includes(:searchable).unique_by_searchable.limit(10) if current_user
  end

  # @route GET /search (search)
  def show
    @query = params[:query]
    @recent_searches = current_user.recent_searches.includes(:searchable).unique_by_searchable.limit(10) if current_user
    ui.replace("search-results", with: "show")
  end

  private

  def search_categories_options
    [
      ["All", "all"],
      ["Videos", "video"],
      ["Dancers", "dancer"],
      ["Songs", "song"],
      ["Orchestras", "orchestra"],
      ["Channels", "channel"],
      ["Events", "event"]
    ]
  end
end
