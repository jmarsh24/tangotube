class Search::ChannelsController < ApplicationController
  def index
    @channels = Rails.cache.fetch(["search_channels", params[:query].presence], expires_in: 1.hour) do
      if params[:query].present?
        Channel.search(params[:query])
          .with_attached_thumbnail
          .limit(10)
      else
        Channel.all.limit(10).order(videos_count: :desc)
      end
    end
  end
end
