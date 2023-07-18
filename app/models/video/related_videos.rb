# frozen_string_literal: true

class Video::RelatedVideos
  attr_reader :video

  def initialize(video)
    @video = video
  end

  def with_same_dancers
    leader = @video.leaders.first.slug
    follower = @video.followers.first.slug
    Video::Filter.new(videos, filtering_params: {leader:, follower:, hidden: false}, excluded_youtube_id: @video.youtube_id).filtered_videos
  end

  def with_same_event
    videos.within_week_of(@video.upload_date)
    event = @video.event.slug
    Video::Filter.new(videos, filtering_params: {event:, hidden: false}, excluded_youtube_id: @video.youtube_id).filtered_videos
  end

  def with_same_song
    videos.has_leader.has_follower
    song = @video.song.slug
    Video::Filter.new(videos, filtering_params: {song:, hidden: false}, excluded_youtube_id: @video.youtube_id).filtered_videos
  end

  def with_same_channel
    videos.has_leader.has_follower
    channel = @video.channel.channel_id
    Video::Filter.new(videos, filtering_params: {channel:, hidden: false}, excluded_youtube_id: @video.youtube_id).filtered_videos
  end

  def with_same_performance
    videos.within_week_of(@video.upload_date)
    leader = @video.leaders.first.slug if @video.leaders.present?
    follower = @video.followers.first.slug if @video.followers.present?
    channel = @video.channel.channel_id
    Video::Filter.new(videos, filtering_params: {channel:, leader:, follower:, hidden: false}).filtered_videos
  end

  private

  def videos
    @videos ||= Video.includes(
      :channel,
      :song,
      dancer_videos: :dancer,
      thumbnail_attachment: :blob
    )
  end
end
