# frozen_string_literal: true

class ChannelsController < ApplicationController
  before_action :set_channel, only: [:show, :edit, :update, :destroy, :deactivate]
  before_action :authenticate_user!, except: [:index, :show]

  # @route GET /channels (channels)
  def index
    @channels = Channel.order(:id).all.limit(10)
    authorize @channels
  end

  # @route GET /channels/:id (channel)
  def show
    authorize @channel
  end

  # @route GET /channels/new (new_channel)
  def new
    @channel = Channel.new
    authorize @channel
  end

  # @route GET /channels/:id/edit (edit_channel)
  def edit
    authorize @channel
  end

  # @route POST /channels (channels)
  def create
    @channel = Channel.new(channel_params)
    @channel.user = current_user
    authorize @channel

    if @channel.save
      fetch_new_channel
      redirect_to @channel
    else
      render :new, status: :unprocessable_entity
    end
  end

  # @route PATCH /channels/:id (channel)
  # @route PUT /channels/:id (channel)
  def update
    authorize @channel

    if @channel.update(channel_params)
      redirect_to @channel
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # @route DELETE /channels/:id (channel)
  def destroy
    authorize @channel
    @channel.destroy
    redirect_to channels_url
  end

  # @route POST /channels/:channel_id/deactivate (channel_deactivate)
  def deactivate
    authorize @channel
    @channel.active = false
    @channel.save
    DestroyAllChannelVideosJob.perform_later(@channel.channel_id)
    redirect_to root_path(channel: @channel.channel_id)
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_channel
    @channel = Channel.find_by(channel_id: channel_params[:channel_id])
  end

  # Only allow a list of trusted parameters through.
  def channel_params
    params.require(:channel).permit(:channel_id, :channel, :id)
  end

  def fetch_new_channel
    ImportChannelJob.perform_later(@channel.channel_id)
  end
end
