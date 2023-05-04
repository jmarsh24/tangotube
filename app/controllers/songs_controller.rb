# frozen_string_literal: true

class SongsController < ApplicationController
  before_action :set_song, only: [:show, :edit, :update, :destroy]

  # @route POST /songs (songs)
  # @route GET /songs (songs)
  def index
    @songs = Song.all.limit(10)
    respond_to do |format|
      format.html
      format.json do
        render json:
        Song.search(params[:q],
          match: :word_middle,
          sort: :title).map { |song| {text: song.full_title, value: song.id} }
      end
    end
  end

  # @route POST /songs/:id (song)
  # @route GET /songs/:id (song)
  def show
  end

  # @route GET /songs/new (new_song)
  def new
    @song = Song.new
  end

  # @route GET /songs/:id/edit (edit_song)
  def edit
  end

  # @route POST /songs (songs)
  def create
    @song = Song.new(song_params)

    if @song.save
      redirect_to @song
    else
      render :new, status: :unprocessable_entity
    end
  end

  # @route PATCH /songs/:id (song)
  # @route PUT /songs/:id (song)
  def update
    if @song.update(song_params)
      redirect_to @song
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # @route DELETE /songs/:id (song)
  def destroy
    @song.destroy
    redirect_to songs_url
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_song
    @song = Song.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def song_params
    params.fetch(:song, {})
  end
end
