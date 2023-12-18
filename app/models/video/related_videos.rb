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

    Video::Filter.new(Video.includes(:dancers), filtering_params:, excluded_youtube_id: @video.youtube_id).videos
  end

  def with_same_event
    return Video.none unless @video.event.present?

    event_id = @video.event.id
    Video.includes(:dancers).within_week_of(@video.upload_date)
      .where(event_id:, hidden: false)
      .where.not(youtube_id: @video.youtube_id)
  end

  def with_same_song
    return Video.none unless @video.song.present?

    song_id = @video.song.id
    Video.includes(:dancers)
      .where(song_id:, hidden: false)
      .where.not(youtube_id: @video.youtube_id)
  end

  def with_same_channel
    return Video.none unless @video.channel.present? && @video.channel.videos_count > 1

    channel_id = @video.channel_id
    Video.includes(:dancers)
      .where(channel_id:, hidden: false)
      .where.not(youtube_id: @video.youtube_id)
  end

  def with_same_performance
    return Video.none unless @video.performance.present?

    @video.performance.videos.preload(:dancers).order("performance_videos.position")
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
