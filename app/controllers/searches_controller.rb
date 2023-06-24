class SearchesController < ApplicationController
  def new
    @categories = search_categories_options
  end

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
      ["Songs", "songs"],
      ["Orchestra", "orchestra"],
      ["Channels", "channels"],
      ["Events", "events"]
    ]
  end
end
