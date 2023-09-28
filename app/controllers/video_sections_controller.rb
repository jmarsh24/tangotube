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

  def dancer
    @dancers = Dancer.most_popular.with_attached_profile_image.limit(128).shuffle.take(24)
    @dancer = @dancers.sample
    @videos = Video::Search.new(filtering_params: {dancer: @dancer.slug}, user: current_user).videos
      .has_leader.has_follower.not_hidden.from_active_channels
      .limit(36)
      .preload(Video.search_includes)
  end

  def song
    @songs = Song.most_popular.joins(:leaders, :followers).preload(:orchestra).limit(24).shuffle.take(1)
    @song = @songs.sample
    @videos = Video::Search.new(filtering_params: {song: @song.slug}, user: current_user).videos
      .has_leader.has_follower.not_hidden.from_active_channels
      .limit(36)
      .preload(Video.search_includes)
  end

  def channel
    @channels = Channel.most_popular.active.with_attached_thumbnail.limit(12).shuffle.take(1)
    @channel = @channels.sample
    @videos = Video::Search.new(filtering_params: {channel: @channel.youtube_slug}, user: current_user).videos
      .has_leader.has_follower.not_hidden.from_active_channels
      .limit(36)
      .preload(Video.search_includes)
  end

  def orchestra
    @orchestras = Orchestra.most_popular.with_attached_profile_image.limit(24).shuffle.take(1)
    @orchestra = @orchestras.sample
    @videos = Video::Search.new(filtering_params: {orchestra: @orchestra.slug}, user: current_user).videos
      .has_leader.has_follower.not_hidden.from_active_channels
      .limit(36)
      .preload(Video.search_includes)
  end

  private

  def filtering_params
    params.permit(:leader, :follower, :couple, :orchestra, :watched, :song, :channel, :event, :genre).to_h
  end
end
