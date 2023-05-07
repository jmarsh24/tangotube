# frozen_string_literal: true

class SongsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_song, only: [:show, :edit, :update, :destroy]

  # @route POST /songs (songs)
  # @route GET /songs (songs)
  def index
    @songs = Song.all
    authorize @songs
  end

  # @route POST /songs/:id (song)
  # @route GET /songs/:id (song)
  def show
    authorize @song
  end

  # @route GET /songs/new (new_song)
  def new
    @song = Song.new
    authorize @song
  end

  # @route POST /songs (songs)
  def create
    @song = Song.new(song_params)
    authorize @song

    if @song.save
      redirect_to @song, notice: "Song was successfully created."
    else
      render :new
    end
  end

  # @route GET /songs/:id/edit (edit_song)
  def edit
    authorize @song
  end

  # @route PATCH /songs/:id (song)
  # @route PUT /songs/:id (song)
  def update
    authorize @song

    if @song.update(song_params)
      redirect_to @song, notice: "Song was successfully updated."
    else
      render :edit
    end
  end

  # @route DELETE /songs/:id (song)
  def destroy
    authorize @song
    @song.destroy

    redirect_to songs_url, notice: "Song was successfully destroyed."
  end

  private

  def set_song
    @song = Song.find(params[:id])
  end

  def song_params
    params.require(:song).permit(:title, :artist)
  end
end
