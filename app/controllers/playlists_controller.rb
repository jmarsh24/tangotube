class PlaylistsController < ApplicationController
  def index
    @playlists = Playlist.all.order(:id)
  end

  def show
    @playlist = Playlist.find(params[:id])
  end
end
