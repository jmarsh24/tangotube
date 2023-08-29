class VideoSectionsController < ApplicationController
  helper_method :filtering_params

  def recent
    @videos = Video::Search.new(filtering_params:, sort: "most_recent", user: current_user).videos.limit(36).preload(Video.search_includes)
  end

  def oldest
    @videos = Video::Search.new(filtering_params:, sort: "trending_6", user: current_user).videos.limit(36).preload(Video.search_includes)
  end

  def performances
    @videos = Video::Search.new(filtering_params:, sort: "performance", user: current_user).videos.limit(36).preload(Video.search_includes)
  end

  def trending
    @videos = Video::Search.new(filtering_params:, sort: "trending_5", user: current_user).videos.limit(36).preload(Video.search_includes)
  end

  private

  def filtering_params
    params.permit(:leader, :follower, :couple).to_h
  end
end
