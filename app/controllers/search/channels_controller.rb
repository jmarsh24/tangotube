# frozen_string_literal: true

class Search::ChannelsController < ApplicationController
  # @route GET /search/channels (search_channels)
  def index
    @channels = Rails.cache.fetch(["search_channels", params[:query].presence], expires_in: 1.hour) do
      if params[:query].present?
        Channel.search(params[:query])
          .with_attached_thumbnail
          .active
          .limit(100)
      else
        Channel.all.limit(10).order(videos_count: :desc)
      end
    end
  end
end
