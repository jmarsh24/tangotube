class VideoSectionsController < ApplicationController
  helper_method :filtering_params

  def recent
    @videos = Video::Search.new(filtering_params:, sort: "most_recent").videos
      .has_dancer.not_hidden.from_active_channels
      .limit(36)
      .preload(Video.search_includes)
  end

  def older
    @videos = Video::Search.new(filtering_params:, sort: "oldest").videos
      .has_dancer.not_hidden.from_active_channels
      .limit(36)
      .preload(Video.search_includes)
  end

  def performances
    @videos = Video::Search.new(filtering_params:, sort: "performance").videos
      .has_dancer.not_hidden.from_active_channels
      .limit(36)
      .preload(Video.search_includes)
  end

  def trending
    @videos = Video::Search.new(filtering_params:, sort: "trending_5").videos
      .has_dancer.not_hidden.from_active_channels
      .limit(36)
      .preload(Video.search_includes)
  end

  def alternative
    @videos = Video::Search.new(filtering_params: {genre: "alternative"}).videos
      .has_dancer.not_hidden.from_active_channels
      .limit(36)
      .preload(Video.search_includes)
  end

  private

  def filtering_params
    params.permit(:leader, :follower, :couple, :orchestra, :watched, :song, :channel, :event).to_h
  end
end
