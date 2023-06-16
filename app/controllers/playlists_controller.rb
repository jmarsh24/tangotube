# frozen_string_literal: true

class PlaylistsController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_admin!, only: [:create]

  # @route POST /playlists (playlists)
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

  def authorize_admin!
    unless current_user&.admin?
      flash[:alert] = "You are not authorized to perform this action."
      redirect_to root_path
    end
  end
end
