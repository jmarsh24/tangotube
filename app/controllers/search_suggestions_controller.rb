class SearchSuggestionsController < ApplicationController
  def index
    @leaders   = Leader.joins(:videos).distinct.where('unaccent(name) ILIKE unaccent(?)',
                                                      "%#{params[:query]}%").limit(10).pluck(:name)

    @followers = Follower.joins(:videos).distinct.where('unaccent(name) ILIKE unaccent(?)',
                                                        "%#{params[:query]}%").limit(10).pluck(:name)
    @songs = Song.joins(:videos)
                 .search(params[:query])
                 .reorder('')
                 .distinct
                 .limit(10)
                 .pluck('songs.title', 'songs.artist', 'songs.genre').map { |songs| songs.join(' ') }

    @channels = Channel.where('unaccent(title) ILIKE unaccent(?)',
                              "%#{params[:query]}%").limit(10).pluck(:title)

    @suggestions = [@leaders + @followers + @songs + @channels].flatten.uniq.first(10).map(&:titleize)
    render json: @suggestions
  end
end
