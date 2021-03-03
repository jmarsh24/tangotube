class SearchSuggestionsController < ApplicationController
  def index
    @leaders = Leader.joins(:videos)
                     .distinct
                     .full_name_search(params[:query])
                     .limit(10)
                     .pluck(:name)

    @followers = Follower.joins(:videos)
                         .distinct
                         .full_name_search(params[:query])
                         .limit(10)
                         .pluck(:name)

    @songs = Song.joins(:videos)
                 .distinct
                 .full_title_search(params[:query])
                 .limit(10)
                 .map(&:full_title)

    @channels = Channel.title_search(params[:query])
                       .limit(10)
                       .pluck(:title)

    @suggestions = [@leaders + @followers + @songs + @channels].flatten.uniq.first(10).map(&:titleize)
    render json: @suggestions
  end
end
