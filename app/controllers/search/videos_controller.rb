# frozen_string_literal: true

class Search::VideosController < ApplicationController
  # @route GET /search/videos (search_videos)
  def index
    @videos = if params[:query].present?
      paginated(Video.search(params[:query]).not_hidden.from_active_channels.with_attached_thumbnail, per: 12, frame_id: "search_window_videos_results")
    else
      paginated(Video.not_hidden.from_active_channels.most_popular, per: 12, frame_id: "search_window_videos_results")
    end
  end
end
