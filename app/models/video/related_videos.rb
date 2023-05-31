class Video::RelatedVideos
  attr_reader :video

  def initialize(video)
    @video = video
  end

  def with_same_dancers
    Video::Search.new(filtering_params: {leader: @video.leaders.first.slug, follower: @video.followers.first.slug, hidden: false}).videos
      .where.not(youtube_id: @video.youtube_id)
  end

  def with_same_event
    Video::Search.new(filtering_params: {event: @video.event.slug, hidden: false}).videos
      .where("upload_date <= ?", @video.upload_date + 7.days)
      .where("upload_date >= ?", video.upload_date - 7.days)
      .where.not(youtube_id: @video.youtube_id)
  end

  def with_same_song
    Video::Search.new(filtering_params: {song: @video.song.slug, hidden: false}).videos
      .has_leader_and_follower
      .where.not(youtube_id: @video.youtube_id)
      .distinct
  end

  def with_same_channel
    Video::Search.new(filtering_params: {channel: @video.channel.channel_id, hidden: false}).videos
      .has_leader_and_follower
      .where.not(youtube_id: @video.youtube_id)
      .distinct
  end

  def with_same_performance
    Video::Search.new(filtering_params: {channel: @video.channel.channel_id, leader: @video.leaders.first.slug, follower: @video.followers.first.slug, hidden: false}).videos
      .where.not(youtube_id: @video.youtube_id)
      .where(upload_date: (@video.upload_date - 7.days)..(@video.upload_date + 7.days))
  end
end
