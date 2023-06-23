# frozen_string_literal: true

class Video::RelatedVideos
  attr_reader :video

  def initialize(video)
    @video = video
  end

  def with_same_dancers
    videos = Video.exclude_youtube_id(@video.youtube_id)
    leader = @video.leaders.first.slug
    follower = @video.followers.first.slug
    Video::Filter.new(videos.includes(Video.search_includes), filtering_params: {leader:, follower:, hidden: false}).filtered_videos
  end

  def with_same_event
    videos = Video.within_week_of(@video.upload_date).exclude_youtube_id(@video.youtube_id)
    event = @video.event.slug
    Video::Filter.new(videos.includes(Video.search_includes), filtering_params: {event:, hidden: false}).filtered_videos
  end

  def with_same_song
    videos = Video.has_leader.has_follower.exclude_youtube_id(@video.youtube_id)
    song = @video.song.slug
    Video::Filter.new(videos.includes(Video.search_includes), filtering_params: {song:, hidden: false}).filtered_videos
  end

  def with_same_channel
    videos = Video.has_leader.has_follower.exclude_youtube_id(@video.youtube_id)
    channel = @video.channel.channel_id
    Video::Filter.new(videos.includes(Video.search_includes), filtering_params: {channel:, hidden: false}).filtered_videos
  end

  def with_same_performance
    videos = Video.exclude_youtube_id(@video.youtube_id).within_week_of(@video.upload_date)
    leader = @video.leaders.first.slug if @video.leaders.present?
    follower = @video.followers.first.slug if @video.followers.present?
    channel = @video.channel.channel_id
    Video::Filter.new(videos.includes(Video.search_includes), filtering_params: {channel:, leader:, follower:, hidden: false}).filtered_videos
  end
end
