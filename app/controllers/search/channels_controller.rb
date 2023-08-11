class Search::ChannelsController < ApplicationController
  def index
    @channels = if params[:query].present?
      Channel.search(params[:query])
        .with_attached_thumbnail
        .order(videos_count: :desc)
        .limit(10)
        .load_async
    else
      Channel.all.limit(10).order(videos_count: :desc).load_async
    end
  end
end
