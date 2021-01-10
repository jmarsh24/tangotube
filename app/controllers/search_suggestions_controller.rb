class SearchSuggestionsController < ApplicationController
  def index
    @leaders   = Leader.joins(:videos).distinct.where('unaccent(name) ILIKE unaccent(?)',
                                                      "%#{params[:q]}%").limit(10).pluck(:name)
    @followers = Follower.joins(:videos).distinct.where('unaccent(name) ILIKE unaccent(?)',
                                                        "%#{params[:q]}%").limit(10).pluck(:name)
    @songs = Song.joins(:videos).distinct
                 .where('unaccent(songs.artist) ILIKE unaccent(?)
                        OR unaccent(songs.title) ILIKE unaccent(?)
                        OR unaccent(songs.genre) ILIKE unaccent(?)',
                        "%#{params[:q]}%",
                        "%#{params[:q]}%",
                        "%#{params[:q]}%")
                 .limit(10)
                 .pluck('songs.title', 'songs.artist', 'songs.genre').map { |songs| songs.join(" - ") }
    @suggestions = [@leaders + @followers + @songs].flatten.first(10).map(&:titleize)
    render layout: false
  end
end
