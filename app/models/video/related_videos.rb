# frozen_string_literal: true

class Video::RelatedVideos
  attr_reader :video

  def initialize(video)
    @video = video
  end

  def with_same_dancers
    return Video.none unless @video.leaders.present? || @video.followers.present?

    dancer_ids = @video.leaders.pluck(:id) + @video.followers.pluck(:id)

    Video.includes(Video.search_includes)
      .where(id: DancerVideo.select(:video_id).where(dancer_id: dancer_ids))
      .where.not(youtube_id: @video.youtube_id)
      .recent_trending
  end

  def with_same_event
    return Video.none unless @video.event.present?

    event_id = @video.event.id
    Video.includes(Video.search_includes).within_week_of(@video.upload_date)
      .has_dancer
      .where(event_id:, hidden: false)
      .where.not(youtube_id: @video.youtube_id)
      .recent_trending
  end

  def with_same_song
    return Video.none unless @video.song.present?

    song_id = @video.song.id
    Video.includes(Video.search_includes)
      .has_dancer
      .where(song_id:, hidden: false)
      .where.not(youtube_id: @video.youtube_id)
      .recent_trending
  end

  def with_same_channel
    return Video.none unless @video.channel.present? && @video.channel.videos_count > 1

    channel_id = @video.channel_id
    Video.includes(Video.search_includes)
      .has_dancer
      .where(channel_id:, hidden: false)
      .where.not(youtube_id: @video.youtube_id)
      .recent_trending
  end

  def with_same_performance
    return Video.none unless @video.performance.present?

    @video.performance.videos.preload(Video.search_includes).order("performance_videos.position")
  end

  def with_same_orchestra
    return Video.none unless @video&.song&.orchestra.present? && @video.song.orchestra.videos_count > 1

    # Fetch the orchestra_id from @video's song
    orchestra_id = @video.song.orchestra_id

    # Return videos with the same orchestra, excluding the current video
    Video.includes(Video.search_includes)
      .joins(:song, :video_score)
      .has_dancer
      .where(songs: {orchestra_id:}, hidden: false)
      .where.not(youtube_id: @video.youtube_id)
      .recent_trending
  end

  def available_types
    types = []
    types << "same_performance" if @video.performance.present?
    types << "same_dancers" if @video.leaders.present? || @video.followers.present?
    types << "same_song" if @video.song.present?
    types << "same_event" if @video.event.present?
    types << "same_channel" if @video.channel.present?
    types << "same_orchestra" if @video.orchestra.present?
    types
  end
end
