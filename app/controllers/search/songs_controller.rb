class Search::SongsController < ApplicationController
  def index
    @songs = if params[:query].present?
      Song.search(params[:query]).load_async
    else
      Song.all.most_popular
    end
  end
end
