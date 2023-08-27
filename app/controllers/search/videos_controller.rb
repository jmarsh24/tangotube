# frozen_string_literal: true

class Search::VideosController < ApplicationController
  # @route GET /search/videos (search_videos)
  def index
    @videos = if params[:query].present?
      paginated(Video.search(params[:query]).not_hidden.from_active_channels.with_attached_thumbnail.preload(:performance, :performance_video, :channel, :dancers, :song), per: 12, frame_id: "search_window_videos_results")
    else
      paginated(Video.not_hidden.from_active_channels.most_popular.with_attached_thumbnail.preload(:performance, :performance_video, :dancers, :channel, :song), per: 12, frame_id: "search_window_videos_results")
    end
  end
end
