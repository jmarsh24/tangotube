# frozen_string_literal: true

class VideoSectionsController < ApplicationController
  helper_method :filtering_params

  # @route GET /video_sections/recent (recent_video_sections)
  def recent
    @videos = Video::Search.new(filtering_params:, sort: "most_recent", user: current_user).videos
      .has_dancer.not_hidden.from_active_channels
      .limit(36)
      .preload(Video.search_includes)
  end

  # @route GET /video_sections/older (older_video_sections)
  def older
    @videos = Video::Search.new(filtering_params:, sort: "oldest", user: current_user).videos
      .has_dancer.not_hidden.from_active_channels
      .limit(36)
      .preload(Video.search_includes)
  end

  # @route GET /video_sections/performances (performances_video_sections)
  def performances
    @videos = Video::Search.new(filtering_params:, sort: "performance", user: current_user).videos
      .has_dancer.not_hidden.from_active_channels
      .limit(36)
      .preload(Video.search_includes)
  end

  # @route GET /video_sections/random_event (random_event_video_sections)
  def random_event
    @event = Event.most_popular.limit(8).sample
    @year = @event.videos.pluck(:upload_date_year).uniq.sample
    @videos = Video::Search.new(filtering_params: {event: @event.slug, year: @year}, sort: "trending_5").videos
      .has_dancer.not_hidden.from_active_channels
      .limit(36)
      .preload(Video.search_includes)
  end

  # @route GET /video_sections/trending (trending_video_sections)
  def trending
    @videos = Video::Search.new(filtering_params:, sort: "trending_5", user: current_user).videos
      .has_dancer.not_hidden.from_active_channels
      .limit(36)
      .preload(Video.search_includes)
  end

  # @route GET /video_sections/alternative (alternative_video_sections)
  def alternative
    @videos = Video::Search.new(filtering_params: {genre: "alternative"}, user: current_user).videos
      .has_dancer.not_hidden.from_active_channels
      .limit(36)
      .preload(Video.search_includes)
  end

  private

  def filtering_params
    params.permit(:leader, :follower, :couple, :orchestra, :watched, :song, :channel, :event, :genre).to_h
  end
end
