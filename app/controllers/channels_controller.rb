class ChannelsController < ApplicationController
  before_action :set_channel, only: %i[ show edit update destroy deactivate ]

  # GET /channels
  def index
    @channels = Channel.order(:id).all.limit(10)
  end

  # GET /channels/1
  def show; end

  # GET /channels/new
  def new
    @channel = Channel.new
  end

  # GET /channels/1/edit
  def edit; end

  # POST /channels
  def create
    @channel = Channel.new(channel_params)

    if @channel.save
      fetch_new_channel
      redirect_to @channel, notice: "Channel was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /channels/1
  def update
    if @channel.update(channel_params)
      redirect_to @channel, notice: "Channel was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /channels/1
  def destroy
    @channel.destroy
    redirect_to channels_url, notice: "Channel was successfully destroyed."
  end

  def deactivate
    @channel.active = false
    @channel.save
    DestroyAllChannelVideosJob.perform_async(@channel.channel_id)
    redirect_to root_path(channel: @channel.channel_id), notice: "Channel has been inactivated"
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
      ImportChannelWorker.perform_async(@channel.channel_id)
    end
end
