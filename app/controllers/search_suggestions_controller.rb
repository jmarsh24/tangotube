class SearchSuggestionsController < ApplicationController
  def search
    @leaders = Leader.search(params[:query]).map(&:full_name)

    @followers = Follower.search(params[:query]).map(&:full_name)

    @songs = Song.search(params[:query]).map(&:full_title)

    @channels = Channel.search(params[:query]).map(&:title)

    return @search_results = [] if params[:query].blank?

      @search_results =
        [@leaders + @followers + @songs + @channels].flatten
          .uniq
          .first(10)
          .map(&:titleize)

    respond_to do |format|
      format.turbo_stream
    end
  end
end
