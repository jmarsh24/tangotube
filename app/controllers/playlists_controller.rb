# frozen_string_literal: true

class PlaylistsController < ApplicationController
  def index
    @playlists = Playlist.all.order(:id)
  end

  def create
    @playlist = Playlist.create(slug: params[:playlist][:slug])
    fetch_new_playlist

    redirect_to root_path,
      notice:
        "Playlist Sucessfully Added: The playlist must be approved before the videos are added"
  end

  private

  def fetch_new_playlist
    ImportPlaylistJob.perform_later(@playlist.slug)
  end
end
