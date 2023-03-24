# frozen_string_literal: true

class PlaylistsController < ApplicationController
  # @route GET /playlists (playlists)
  def index
    @playlists = Playlist.all.order(:id)
  end

  # @route POST /playlists (playlists)
  def create
    @playlist = Playlist.create(slug: params[:playlist][:slug])
    fetch_new_playlist

    redirect_to root_path
  end

  private

  def fetch_new_playlist
    ImportPlaylistJob.perform_later(@playlist.slug)
  end
end
