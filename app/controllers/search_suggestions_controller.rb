class SearchSuggestionsController < ApplicationController
  def search
    @leaders =
      Leader
        .joins(:videos)
        .distinct
        .full_name_search(params[:query])
        .limit(10)
        .pluck(:name)

    @followers =
      Follower
        .joins(:videos)
        .distinct
        .full_name_search(params[:query])
        .limit(10)
        .pluck(:name)

    @songs =
      Song
        .joins(:videos)
        .distinct
        .full_title_search(params[:query])
        .limit(10)
        .map(&:full_title)

    @channels = Channel.title_search(params[:query]).limit(10).pluck(:title)

    return @search_results = [] if params[:query].blank?

      @search_results =
        [@leaders + @followers + @songs + @channels].flatten
          .uniq
          .first(10)
          .map(&:titleize)


    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.update("search_results",
          partial: "search_suggestions/search_results",
          locals: { search_results: @search_results })
        ]
      end
    end
  end
end
