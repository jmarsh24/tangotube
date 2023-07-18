# frozen_string_literal: true

class Video::RelatedVideos
  attr_reader :video

  def initialize(video)
    @video = video
  end

  def with_same_dancers
    return Video.none unless @video.leaders.present? && @video.followers.present?

    leader = @video.leaders.first.slug
    follower = @video.followers.first.slug
    Video::Filter.new(Video.all, filtering_params: {leader:, follower:, hidden: false}, excluded_youtube_id: @video.youtube_id).filtered_videos
  end

  def with_same_event
    return Video.none unless @video.event.present?

    videos = Video.within_week_of(@video.upload_date)
    event = @video.event.slug
    Video::Filter.new(videos, filtering_params: {event:, hidden: false}, excluded_youtube_id: @video.youtube_id).filtered_videos
  end

  def with_same_song
    return Video.none unless @video.song.present?

    videos = Video.joins(:dancer_videos)
    song = @video.song.slug
    video_ids = Video::Filter.new(videos, filtering_params: {song:, hidden: false}, excluded_youtube_id: @video.youtube_id).filtered_videos.pluck(:id).uniq
    Video.find(video_ids)
  end

  def with_same_channel
    return Video.none unless @video.channel.present?

    videos = Video.joins(:dancer_videos)
    channel = @video.channel.channel_id
    Video::Filter.new(videos, filtering_params: {channel:, hidden: false}, excluded_youtube_id: @video.youtube_id).filtered_videos
  end

  def with_same_performance
    return Video.none unless @video.performance.present?

    videos = Video.within_week_of(@video.upload_date)
    leader = @video.leaders.first.slug if @video.leaders.present?
    follower = @video.followers.first.slug if @video.followers.present?
    channel = @video.channel.channel_id
    Video::Filter.new(videos, filtering_params: {channel:, leader:, follower:, hidden: false}).filtered_videos
  end
end
