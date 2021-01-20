class ChannelsController < ApplicationController

  def index
    @channels = Channel.order(:id).all
  end

end
