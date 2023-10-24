# frozen_string_literal: true

class Search::ChannelsController < ApplicationController
  # @route GET /search/channels (search_channels)
  def index
    @channels =
      if params[:query].present?
        Channel.search(params[:query])
          .with_attached_thumbnail
          .active
          .limit(100)
          .load_async
      else
        Channel.with_attached_thumbnail
          .active.limit(100).order(videos_count: :desc).load_async
      end
  end
end
