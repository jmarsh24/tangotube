
class Video::Recommendation
  attr_reader :video

  def initialize(video)
    @video = video
  end

  def with_same_dancers
    binding.pry
    Video::Search.new(filtering_params: {leader: @video.leaders.first.slug, follower: @video.followers.first.slug}).perform_search
      .where(hidden: false)
      .where.not(youtube_id: @video.youtube_id)
  end

  def with_same_event
    Video
      .includes(Video.search_includes)
      .where(event_id: @video.event_id)
      .where.not(event: nil)
      .where("upload_date <= ?", @video.upload_date + 7.days)
      .where("upload_date >= ?", video.upload_date - 7.days)
      .where(hidden: false)
      .where.not(youtube_id: @video.youtube_id)
  end

  def with_same_song
    Video
      .includes(Video.search_includes)
      .where(song_id: @video.song_id)
      .has_leader_and_follower
      .where(hidden: false)
      .where.not(song_id: nil)
      .where.not(youtube_id: @video.youtube_id)
  end

  def with_same_channel
    Video
      .includes(Video.search_includes)
      .where(channel_id: @video.channel_id)
      .has_leader_and_follower
      .where(hidden: false)
      .where.not(youtube_id: @video.youtube_id)
  end

  def with_same_performance
    Video
      .includes(Video.search_includes)
      .where(channel_id: @video.channel_id)
      .has_leader_and_follower
      .where(hidden: false)
      .where.not(youtube_id: @video.youtube_id)
      .where(upload_date: (@video.upload_date - 7.days)..(@video.upload_date + 7.days))
  end
end
