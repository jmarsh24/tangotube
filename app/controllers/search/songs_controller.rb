class Search::SongsController < ApplicationController
  def index
    @songs = if params[:query].present?
      Song.search(params[:query]).load_async
    else
      Song.all.limit(10).order(created_at: :desc).load_async
    end
  end
end
