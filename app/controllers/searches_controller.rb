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
    ui.replace("search-results", with: "show")

    # selected_category = params[:category] || "all"
    # categories = search_categories_options
    # search = Search.new(query: params[:query], category: selected_category)

    # ui.replace("search-results", with: "searches/results", results:)
    # ui.replace("search-header-categories", with: "searches/categories", selected_category:, categories:)
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
