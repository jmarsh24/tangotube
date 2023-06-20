class SearchesController < ApplicationController
  def new
    @categories = search_categories_options
    @selected_category = params[:category] || "top"
  end

  def show
    selected_category = params[:category] || "top"
    categories = search_categories_options
    search = Search.new(term: params[:search], category: selected_category)
    ui.replace("search-results", with: "searches/results", search:)
    ui.replace("search-header-categories", with: "searches/categories", selected_category:, categories:)
  end

  private

  def search_categories_options
    [
      ["Top", "top"],
      ["Songs", "songs"],
      ["Channels", "channels"],
      # ["Dancers", "dancers"],
      ["Events", "events"],
      ["Orchestra", "orchestra"],
      ["Videos", "videos"]
    ]
  end
end
