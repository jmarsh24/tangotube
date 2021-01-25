class PlaylistsController < ApplicationController
  def index
    @playlists = Playlist.all.order(:id)
  end

  def show; end

  private

  def set_playlist
    @playlist = Playlist.find(params[:id])
  end
end
