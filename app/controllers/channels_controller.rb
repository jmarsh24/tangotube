class ChannelsController < ApplicationController
  def index
    @channels = Channel.order(:id).all
  end

  def show; end

  private

  def set_channel
    @channel = Channel.find(params[:id])
  end
end
