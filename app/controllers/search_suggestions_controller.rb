class SearchSuggestionsController < ApplicationController
  def index
    @leaders = Leader.where('unaccent(name) ILIKE ?', "%#{params[:q]}%").limit(5).pluck(:name)
    @followers = Follower.where('unaccent(name) ILIKE ?', "%#{params[:q]}%").limit(5).pluck(:name)
    @songs = Song.where('unaccent(artist) ILIKE ?
                        OR unaccent(title) ILIKE ?
                        OR unaccent(genre)ILIKE ?',
                        "%#{params[:q]}%",
                        "%#{params[:q]}%",
                        "%#{params[:q]}%")
                 .limit(5)
                 .distinct
                 .pluck("title || ' | ' || artist || ' | ' || genre")
    @suggestions = [@leaders + @followers + @songs].flatten.first(5).map(&:titleize)
    render layout: false
  end
end
