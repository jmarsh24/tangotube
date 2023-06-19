class SearchesController < ApplicationController
  def new
    @categories = search_categories_options
    @selected_category = params[:category]
  end

  def show
    selected_category = params[:category]
    search = Search.new(term: params[:search], category: selected_category)
    ui.replace "search-results", with: "searches/results", search:, selected_category:
  end

  private

  def search_categories_options
    [
      ["All", nil],
      ["Songs", "songs"],
      ["Channels", "channels"],
      # ["Dancers", "dancers"],
      ["Events", "events"],
      ["Orchestra", "orchestra"],
      ["Videos", "videos"],
      ["Top", "top"]
    ]
  end
end
