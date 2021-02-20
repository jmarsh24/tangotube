class SearchSuggestionsController < ApplicationController
  def index
    @leaders   = Leader.joins(:videos)
                       .distinct
                       .where('unaccent(name) ILIKE unaccent(:query) OR
                                unaccent(first_name) ILIKE unaccent(:query) OR
                                unaccent(last_name) ILIKE unaccent(:query)',
                              query: "%#{params[:query]}%").limit(10).pluck(:name)

    @followers = Follower.joins(:videos)
                         .distinct
                         .where('unaccent(name) ILIKE unaccent(:query) OR
                                  unaccent(first_name) ILIKE unaccent(:query) OR
                                  unaccent(last_name) ILIKE unaccent(:query)',
                                query: "%#{params[:query]}%").limit(10).pluck(:name)
    @songs = Song.joins(:videos)
                 .where('unaccent(songs.title) ILIKE unaccent(:query) OR
                          unaccent(artist) ILIKE unaccent(:query) OR
                          unaccent(genre) ILIKE unaccent(:query)',
                        query: "%#{params[:query]}%")
                 .references(:song)
                 .distinct
                 .limit(10)
                 .map { |songs| songs.full_title }

    @channels = Channel.where('unaccent(title) ILIKE unaccent(?)',
                              "%#{params[:query]}%").limit(10).pluck(:title)

    @suggestions = [@leaders + @followers + @songs + @channels].flatten.uniq.first(10).map(&:titleize)
    render json: @suggestions
  end
end
