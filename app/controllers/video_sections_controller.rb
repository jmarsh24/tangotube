# frozen_string_literal: true

class VideoSectionsController < ApplicationController
  helper_method :filtering_params

  # @route GET /video_sections/recent (recent_video_sections)
  def recent
    @videos = Video::Search.new(filtering_params: {watched: params[:watched]}, sort: "most_recent", user: current_user).videos
      .has_dancer.not_hidden.from_active_channels
      .limit(36)
      .preload(Video.search_includes)
  end

  # @route GET /video_sections/older (older_video_sections)
  def older
    @videos = Video::Search.new(filtering_params: {watched: params[:watched]}, sort: "oldest", user: current_user).videos
      .has_dancer.not_hidden.from_active_channels
      .limit(36)
      .preload(Video.search_includes)
  end

  # @route GET /video_sections/performances (performances_video_sections)
  def performances
    @videos = Video::Search.new(filtering_params: {watched: params[:watched]}, sort: "performance", user: current_user).videos
      .has_dancer.not_hidden.from_active_channels
      .limit(36)
      .preload(Video.search_includes)
  end

  # @route GET /video_sections/event (event_video_sections)
  def event
    @events = Event.most_popular.limit(8)
    @event = @events.sample
    @videos = Video::Search.new(filtering_params: {watched: params[:watched], event: @event.slug, year: @year}, sort: "trending_5", user: current_user).videos
      .has_dancer.not_hidden.from_active_channels
      .limit(36)
      .preload(Video.search_includes)
  end

  # @route GET /video_sections/trending (trending_video_sections)
  def trending
    @videos = Video::Search.new(filtering_params: {watched: params[:watched]}, sort: "trending_5", user: current_user).videos
      .has_dancer.not_hidden.from_active_channels
      .limit(36)
      .preload(Video.search_includes)
  end

  # @route GET /video_sections/alternative (alternative_video_sections)
  def alternative
    @videos = Video::Search.new(filtering_params: {watched: params[:watched], genre: "alternative"}, user: current_user).videos
      .has_dancer.not_hidden.from_active_channels
      .limit(36)
      .preload(Video.search_includes)
  end

  # @route GET /video_sections/dancer (dancer_video_sections)
  def dancer
    @dancers = Dancer.most_popular.with_attached_profile_image.limit(128).shuffle.take(24)
    @dancer = @dancers.sample
    @videos = Video::Search.new(filtering_params: {watched: params[:watched], dancer: @dancer.slug}, user: current_user).videos
      .has_leader.has_follower.not_hidden.from_active_channels
      .limit(36)
      .preload(Video.search_includes)
  end

  # @route GET /video_sections/song (song_video_sections)
  def song
    @songs = Song.most_popular.preload(:orchestra).where(
      Video.joins(:dancer_videos)
        .where("videos.song_id = songs.id")
        .arel.exists
    ).order(videos_count: :desc).limit(48).take(24).shuffle
    @song = @songs.sample
    @videos = Video::Search.new(filtering_params: {watched: params[:watched], song: @song.slug}, user: current_user).videos
      .has_leader.has_follower.not_hidden.from_active_channels
      .limit(36)
      .preload(Video.search_includes)
  end

  # @route GET /video_sections/channel (channel_video_sections)
  def channel
    @channels = Channel.most_popular.active.with_attached_thumbnail.limit(12).shuffle
    @channel = @channels.sample
    @videos = Video::Search.new(filtering_params: {watched: params[:watched], channel: @channel.youtube_slug}, user: current_user).videos
      .has_leader.has_follower.not_hidden.from_active_channels
      .limit(36)
      .preload(Video.search_includes)
  end

  # @route GET /video_sections/orchestra (orchestra_video_sections)
  def orchestra
    @orchestras = Orchestra.most_popular.with_attached_profile_image.limit(24).shuffle
    @orchestra = @orchestras.sample
    @videos = Video::Search.new(filtering_params: {watched: params[:watched], orchestra: @orchestra.slug}, user: current_user).videos
      .has_leader.has_follower.not_hidden.from_active_channels
      .limit(36)
      .preload(Video.search_includes)
  end

  def interview
    interview_videos = Video.title_match(["entrevista", "interview", "tengo una pregunta para vos", "podcast", "tango musicality", "documentary", "tango history", "opinions", "tango music visualization", "tango magazine", "what is tango freestyle"])
    @videos = Video::Filter.new(interview_videos, filtering_params: {watched: params[:watched]}, user: current_user).videos
      .has_dancer.not_hidden.from_active_channels
      .limit(500)
      .preload(Video.search_includes)
      .shuffle.take(36)
  end

  def workshop
    class_videos = Video.title_match(["workshop", "class", "clase", "resume", "musicality", "demo", "sacadas", "giros", "colgadas", "technique", "variacion"])
    @videos = Video::Filter.new(class_videos, filtering_params: {watched: params[:watched]}, user: current_user).videos
      .not_hidden.from_active_channels
      .limit(500)
      .preload(Video.search_includes)
      .shuffle.take(36)
  end

  def mundial
    mundial_videos = Video.where("videos.title ILIKE ?", "%mundial de tango 2023%")
    @videos = Video::Filter.new(mundial_videos, filtering_params: {watched: params[:watched]}, user: current_user).videos
      .not_hidden.from_active_channels
      .limit(500)
      .preload(Video.search_includes)
      .shuffle.take(36)
  end

  private

  def filtering_params
    params.permit(:dancer, :leader, :follower, :couple, :orchestra, :watched, :song, :channel, :event, :genre).to_h
  end
end
