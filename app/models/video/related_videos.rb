class Video::RelatedVideos
  attr_reader :video

  def initialize(video)
    @video = video
  end

  def with_same_dancers 
    videos = Video.exclude_youtube_id(@video.youtube_id)
    Video::Filter.new(videos, filtering_params: {leader: @video.leaders.first.slug, follower: @video.followers.first.slug, hidden: false}).videos
  end

  def with_same_event
    videos = Video.within_week_of(@video.upload_date).exclude_youtube_id(@video.youtube_id)
    Video::Filter.new(videos, filtering_params: {event: @video.event.slug, hidden: false}).videos    
  end

  def with_same_song
    videos = Video.has_leader.has_follower.exclude_youtube_id(@video.youtube_id)
    Video::Filter.new(videos, filtering_params: {song: @video.song.slug, hidden: false}).videos      
  end

  def with_same_channel
    videos = Video.has_leader.has_follower.exclude_youtube_id(@video.youtube_id)
    Video::Filter.new(videos, filtering_params: {channel: @video.channel.channel_id, hidden: false}).videos
  end

  def with_same_performance
    videos = Video.exclude_youtube_id(@video.youtube_id).within_week_of(@video.upload_date)
    Video::Filter.new(videos, filtering_params: {channel: @video.channel.channel_id, leader: @video.leaders.first.slug, follower: @video.followers.first.slug, hidden: false}).videos
  end
end
