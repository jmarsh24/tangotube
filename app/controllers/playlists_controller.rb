class PlaylistsController < ApplicationController
  def index
    @playlists = Playlist.all.order(:id)
  end

  def show
    @playlist = Playlist.find(params[:id])
  end

  def create
    Playlist.create(slug: params[:playlist][:slug])

    redirect_to videos_path
  end
end
