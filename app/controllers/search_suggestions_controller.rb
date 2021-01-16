class SearchSuggestionsController < ApplicationController
  def index



    @leaders   = Leader.joins(:videos).distinct.where('unaccent(name) ILIKE unaccent(?)',
                                                      "%#{params[:q]}%").limit(10).pluck(:name)

    @followers = Follower.joins(:videos).distinct.where('unaccent(name) ILIKE unaccent(?)',
                                                        "%#{params[:q]}%").limit(10).pluck(:name)
        @songs = Song.joins(:videos)
                     .search(params[:q])
                     .reorder('')
                     .distinct
                     .limit(10)
                     .pluck('songs.title', 'songs.artist', 'songs.genre').map { |songs| songs.join(" ") }

      @channels = Channel.where('unaccent(title) ILIKE unaccent(?)',
                                                        "%#{params[:q]}%").limit(10).pluck(:title)

    @suggestions = [@leaders + @followers + @songs + @channels].flatten.first(10).map(&:titleize)
    render layout: false
  end
end
