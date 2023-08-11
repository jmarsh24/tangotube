class Search::ChannelsController < ApplicationController
  def index
    @channels = if params[:query].present?
      Channel.search(params[:query]).load_async
    else
      Channel.all
    end
  end
end
