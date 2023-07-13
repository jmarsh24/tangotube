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
    search = Search.new(term: params[:search], category: selected_category)
    ui.replace("search-results", with: "searches/results", search:)
    ui.replace("search-header-categories", with: "searches/categories", selected_category:, categories:)
  end

  private

  def search_categories_options
    [
      ["All", "all"],
      ["Videos", "videos"],
      ["Dancers", "dancers"],
      ["Songs", "songs"],
      ["Orchestras", "orchestras"],
      ["Channels", "channels"],
      ["Events", "events"]
    ]
  end
end
