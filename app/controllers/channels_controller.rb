class ChannelsController < ApplicationController
  def index
    @channels = Channel.order(:id).all
  end

  def show
    @channel = Channel.find(params[:id])
  end
end
