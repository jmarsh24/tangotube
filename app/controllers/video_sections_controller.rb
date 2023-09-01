class VideoSectionsController < ApplicationController
  helper_method :filtering_params

  def recent
    @videos = Video::Search.new(filtering_params:, sort: "most_recent", user: current_user).videos
      .not_hidden.from_active_channels.limit(36).preload(Video.search_includes)
  end

  def oldest
    @videos = Video::Search.new(filtering_params:, sort: "trending_6", user: current_user).videos
      .not_hidden.from_active_channels.limit(36).preload(Video.search_includes)
  end

  def performances
    @videos = Video::Search.new(filtering_params:, sort: "performance", user: current_user).videos
      .not_hidden.from_active_channels.limit(36).preload(Video.search_includes)
  end

  def trending
    @videos = Video::Search.new(filtering_params:, sort: "trending_5", user: current_user).videos
      .not_hidden.from_active_channels.limit(36).preload(Video.search_includes)
  end

  def random_event
    @event = Event.most_popular.limit(24).sample
    @year = @event.videos.pluck(:upload_date_year).uniq.sample
    @videos = Video::Search.new(filtering_params: {event: @event.slug, year: @year}, sort: "trending_5", user: current_user).videos
      .has_leader.has_follower.not_hidden.from_active_channels.limit(36).preload(Video.search_includes)
  end

  def alternative
    @videos = Video::Search.new(filtering_params: {genre: "alternative"}, user: current_user).videos
      .has_leader.has_follower.not_hidden.from_active_channels.limit(36).preload(Video.search_includes)
  end

  private

  def filtering_params
    params.permit(:leader, :follower, :couple, :orchestra, :watched, :song).to_h
  end
end
