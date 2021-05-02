class SongsController < ApplicationController
  def index
    @songs =
      Song
        .full_title_search(params[:q])
        .distinct
        .order(:title)
        .map { |song| [song.full_title, song.id] }
    render json: @songs
  end
end
