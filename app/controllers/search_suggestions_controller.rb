# frozen_string_literal: true

class SearchSuggestionsController < ApplicationController
  def search
    @dancers = Dancer.search_by_full_name(params[:query]).map(&:full_name)
    @songs = Song.where("title ILIKE ?", "%#{params[:query]}%").map(&:full_title)

    @channels = Channel.where("title ILIKE ?", "%#{params[:query]}%").map(&:title)

    @search_results = []

    @search_results =
      [@dancers + @songs + @channels].flatten
        .uniq
        .first(10)
        .map(&:titleize)
    ui.update "search_results", with: "search_suggestions/search_results", search_results: @search_results
  end
end
