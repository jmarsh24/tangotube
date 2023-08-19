# frozen_string_literal: true

class SearchesController < ApplicationController
  # @route GET /search/new (new_search)
  def new
    @categories = search_categories_options
  end

  # @route GET /search (search)
  def show
    @query = params[:query]
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
