class ChannelsController < ApplicationController
  after_action :fetch_new_channel, only: :create

  def index
    @channels = Channel.order(:id).all
  end

  def show
    @channel = Channel.find(params[:id])
  end

  def create
    @channel = Channel.create(channel_id: params[:channel][:channel_id])

    redirect_to videos_path, notice: "Channel Sucessfully Added: The channel must be approved before the videos are added"
  end

  private

  def fetch_new_channel
    Video::YoutubeImport::Channel.import(@channel.channel_id)
  end
end
