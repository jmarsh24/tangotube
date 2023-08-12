class Search::SongsController < ApplicationController
  def index
    @songs =
      if params[:query].present?
        Song.search(params[:query]).limit(10)
      else
        Song.all.limit(10).most_popular
      end
  end
end
