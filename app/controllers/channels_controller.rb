# frozen_string_literal: true

class ChannelsController < ApplicationController
  before_action :set_channel, only: [:show, :edit, :update, :destroy, :deactivate]

  # @route GET /channels (channels)
  def index
    @channels = Channel.order(:id).all.limit(10)
  end

  # @route GET /channels/:id (channel)
  def show
  end

  # @route GET /channels/new (new_channel)
  def new
    @channel = Channel.new
  end

  # @route GET /channels/:id/edit (edit_channel)
  def edit
  end

  # @route POST /channels (channels)
  def create
    @channel = Channel.new(channel_params)

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
    if @channel.update(channel_params)
      redirect_to @channel
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # @route DELETE /channels/:id (channel)
  def destroy
    @channel.destroy
    redirect_to channels_url
  end

  # @route POST /channels/:channel_id/deactivate (channel_deactivate)
  def deactivate
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
    params.permit(:channel_id, :channel, :id)
  end

  def fetch_new_channel
    ImportChannelJob.perform_later(@channel.channel_id)
  end
end
