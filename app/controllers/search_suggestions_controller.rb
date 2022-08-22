class SearchSuggestionsController < ApplicationController
  def search
    @leaders = Leader.where("name ILIKE ?", "%#{params[:query]}%").map(&:full_name)

    @followers = Follower.where("name ILIKE ?", "%#{params[:query]}%").map(&:full_name)

    @songs = Song.where("title ILIKE ?", "%#{params[:query]}%").map(&:full_title)

    @channels = Channel.where("title ILIKE ?", "%#{params[:query]}%").map(&:title)

    @search_results = []

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
