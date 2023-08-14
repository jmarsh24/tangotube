# frozen_string_literal: true

class Video::RelatedVideos
  attr_reader :video

  def initialize(video)
    @video = video
  end

  def with_same_dancers
    return Video.none unless @video.leaders.present? || @video.followers.present?

    filtering_params = {hidden: false}
    filtering_params[:leader] = @video.leaders.first.slug if @video.leaders.present?
    filtering_params[:follower] = @video.followers.first.slug if @video.followers.present?

    Video::Filter.new(Video.all.includes(:dancers), filtering_params:, excluded_youtube_id: @video.youtube_id).videos
  end

  def with_same_event
    return Video.none unless @video.event.present?

    videos = Video.within_week_of(@video.upload_date)
    event = @video.event.slug
    Video::Filter.new(videos, filtering_params: {event:, hidden: false}, excluded_youtube_id: @video.youtube_id).videos
  end

  def with_same_song
    return Video.none unless @video.song.present?

    videos = Video.joins(:dancer_videos)
    song = @video.song.slug
    video_ids = Video::Filter.new(videos, filtering_params: {song:, hidden: false}, excluded_youtube_id: @video.youtube_id).videos.pluck(:id)
    Video.where(id: video_ids)
  end

  def with_same_channel
    return Video.none unless @video.channel.present? && @video.channel.videos_count > 1

    channel = @video.channel.youtube_slug
    Video::Filter.new(Video.all, filtering_params: {channel:, hidden: false}, excluded_youtube_id: @video.youtube_id).videos
  end

  def with_same_performance
    return Video.none unless @video.performance.present?

    videos = Video.within_week_of(@video.upload_date)
    leader = @video.leaders.first.slug if @video.leaders.present?
    follower = @video.followers.first.slug if @video.followers.present?
    channel = @video.channel.youtube_slug
    filtered_videos = Video::Filter.new(videos, filtering_params: {channel:, leader:, follower:, hidden: false}).videos
    Video::Sort.new(filtered_videos, sort: "performance").videos
  end

  def available_types
    types = []
    types << "same_performance" if @video.performance.present?
    types << "same_dancers" if @video.leaders.present? || @video.followers.present?
    types << "same_song" if @video.song.present?
    types << "same_event" if @video.event.present?
    types << "same_channel" if @video.channel.present?
    types
  end
end
