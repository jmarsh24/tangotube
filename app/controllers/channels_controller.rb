class ChannelsController < ApplicationController
  def index
    @channels = Channel.order(:id).all
  end

  def create
    @channel = Channel.create(channel_id: params[:channel][:channel_id])
    fetch_new_channel

    redirect_to root_path,
                notice:
                  "Channel Sucessfully Added: The channel must be approved before the videos are added"
  end

  private

  def fetch_new_channel
    ImportChannelWorker.perform_async(@channel.channel_id)
  end
end
