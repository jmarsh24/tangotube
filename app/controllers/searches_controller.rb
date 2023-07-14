# frozen_string_literal: true

class SearchesController < ApplicationController
  # @route GET /search/new (new_search)
  def new
    @categories = search_categories_options
  end

  # @route GET /search (search)
  def show
    selected_category = params[:category] || "all"
    categories = search_categories_options
    results = Search.new(term: params[:search], category: selected_category).results
    ui.replace("search-results", with: "searches/results", results:)
    ui.replace("search-header-categories", with: "searches/categories", selected_category:, categories:)
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
