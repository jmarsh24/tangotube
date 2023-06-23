# frozen_string_literal: true

class Video::RelatedVideos
  attr_reader :video

  def initialize(video)
    @video = video
    @videos = Video.includes(Video.search_includes)
  end

  def with_same_dancers
    leader = @video.leaders.first.slug
    follower = @video.followers.first.slug
    Video::Filter.new(@videos, filtering_params: {leader:, follower:, hidden: false}).filtered_videos
  end

  def with_same_event
    videos = @videos.within_week_of(@video.upload_date)
    event = @video.event.slug
    Video::Filter.new(videos, filtering_params: {event:, hidden: false}).filtered_videos
  end

  def with_same_song
    videos = @videos.has_leader.has_follower
    song = @video.song.slug
    Video::Filter.new(videos, filtering_params: {song:, hidden: false}).filtered_videos
  end

  def with_same_channel
    videos = @videos.has_leader.has_follower
    channel = @video.channel.channel_id
    Video::Filter.new(videos, filtering_params: {channel:, hidden: false}).filtered_videos
  end

  def with_same_performance
    videos = @videos.within_week_of(@video.upload_date)
    leader = @video.leaders.first.slug if @video.leaders.present?
    follower = @video.followers.first.slug if @video.followers.present?
    channel = @video.channel.channel_id
    Video::Filter.new(videos, filtering_params: {channel:, leader:, follower:, hidden: false}).filtered_videos
  end
end
