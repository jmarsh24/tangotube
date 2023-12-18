# frozen_string_literal: true

class VideoSectionsController < ApplicationController
  helper_method :filtering_params
  before_action :require_turbo_frame

  # @route GET /video_sections/trending (trending_video_sections)
  def trending
    videos = Video::Search.new(filtering_params:, sort: "popular_trending", user: current_user).videos
      .has_dancer.not_hidden.from_active_channels
      .limit(36)
      .preload(Video.search_includes)
      .load_async
      .shuffle
    @videos = (videos.count >= 24) ? videos : Video.none
  end

  # @route GET /video_sections/recent (recent_video_sections)
  def recent
    videos = Video::Search.new(filtering_params:, sort: "most_recent", user: current_user).videos
      .has_dancer.not_hidden.from_active_channels
      .limit(36)
      .preload(Video.search_includes)
      .load_async
      .shuffle
    @videos = (videos.count >= 24) ? videos : Video.none
  end

  # @route GET /video_sections/older (older_video_sections)
  def older
    videos = Video::Search.new(filtering_params:, sort: "older_trending", user: current_user).videos
      .has_dancer.not_hidden.from_active_channels
      .limit(36)
      .preload(Video.search_includes)
      .load_async
      .shuffle
    @videos = (videos.count >= 24) ? videos : Video.none
  end

  # @route GET /video_sections/performances (performances_video_sections)
  def performances
    @videos = Video::Search.new(filtering_params:, sort: "performance", user: current_user).videos
      .has_dancer.not_hidden.from_active_channels
      .limit(36)
      .preload(Video.search_includes)
      .load_async
  end

  # @route GET /video_sections/event (event_video_sections)
  def event
    @events = Event.most_popular.limit(24)
    @event = @events.sample
    @videos = Video::Search.new(filtering_params: filtering_params.merge(event: @event.slug, year: @year), sort: "older_trending", user: current_user).videos
      .has_dancer.not_hidden.from_active_channels
      .limit(36)
      .preload(Video.search_includes)
      .load_async
      .shuffle
  end

  # @route GET /video_sections/alternative (alternative_video_sections)
  def alternative
    @videos = Video::Search.new(filtering_params: filtering_params.merge(genre: "alternative"), user: current_user).videos
      .has_dancer.not_hidden.from_active_channels
      .limit(36)
      .preload(Video.search_includes)
      .load_async
      .shuffle
  end

  # @route GET /video_sections/dancer (dancer_video_sections)
  def dancer
    @dancers = Dancer.most_popular.with_attached_profile_image.limit(128).shuffle.take(24)
    @dancer = @dancers.sample
    @videos = Video::Search.new(filtering_params: filtering_params.merge(dancer: @dancer.slug), user: current_user).videos
      .has_leader.has_follower.not_hidden.from_active_channels
      .limit(36)
      .preload(Video.search_includes)
      .load_async
  end

  # @route GET /video_sections/song (song_video_sections)
  def song
    @songs = Song.most_popular.preload(:orchestra).where(
      Video.joins(:dancer_videos)
        .where("videos.song_id = songs.id")
        .arel.exists
    ).order(videos_count: :desc).limit(48).take(24).shuffle
    @song = @songs.sample
    @videos = Video::Search.new(filtering_params: filtering_params.merge(song: @song.slug), user: current_user).videos
      .has_leader.has_follower.not_hidden.from_active_channels
      .limit(36)
      .preload(Video.search_includes)
      .load_async
  end

  # @route GET /video_sections/channel (channel_video_sections)
  def channel
    @channels = Channel.most_popular.active.with_attached_thumbnail.limit(12).shuffle
    @channel = @channels.sample
    @videos = Video::Search.new(filtering_params: filtering_params.merge(channel: @channel.youtube_slug), user: current_user).videos
      .has_leader.has_follower.not_hidden.from_active_channels
      .limit(36)
      .preload(Video.search_includes)
      .load_async
  end

  # @route GET /video_sections/orchestra (orchestra_video_sections)
  def orchestra
    @orchestras = Orchestra.most_popular.with_attached_profile_image.limit(24).shuffle
    @orchestra = @orchestras.sample
    @videos = Video::Search.new(filtering_params: filtering_params.merge(orchestra: @orchestra.slug), user: current_user).videos
      .has_leader.has_follower.not_hidden.from_active_channels
      .limit(36)
      .preload(Video.search_includes)
      .load_async
  end

  # @route GET /video_sections/interview (interview_video_sections)
  def interview
    @videos = Video.where(category: "interview")
      .has_dancer.not_hidden.from_active_channels.recent_trending
      .limit(500)
      .preload(Video.search_includes)
      .load_async
      .shuffle.take(36)
  end

  # @route GET /video_sections/workshop (workshop_video_sections)
  def workshop
    @videos = Video.where(category: ["class", "workshop"])
      .has_dancer.not_hidden.from_active_channels.recent_trending
      .limit(500)
      .preload(Video.search_includes)
      .load_async
      .shuffle.take(36)
  end

  # @route GET /video_sections/mundial (mundial_video_sections)
  def mundial
    mundial_videos = Video.where("videos.title ILIKE ?", "%mundial de tango 2023%")
    @videos = Video::Filter.new(mundial_videos, filtering_params:, user: current_user).videos
      .not_hidden.from_active_channels
      .limit(500)
      .preload(Video.search_includes)
      .load_async
      .shuffle.take(36)
  end

  # @route GET /video_sections/dancer_song (dancer_song_video_sections)
  def dancer_song
    @dancer = Dancer.find_by(slug: params[:leader]) || Dancer.find_by(slug: params[:follower])

    videos = Video::Search.new(
      filtering_params: filtering_params.merge(dancer: @dancer.slug),
      user: current_user
    ).videos.not_hidden.from_active_channels.preload(Video.search_includes)
      .load_async

    shuffled_grouped_by_song = videos.group_by(&:song_id)
      .select { |_, v| v.length >= 4 }
      .transform_values(&:shuffle)

    random_song_id = shuffled_grouped_by_song.keys.sample

    if random_song_id
      @videos = shuffled_grouped_by_song[random_song_id]
      @song = Song.find(random_song_id)
      @songs = Song.where(id: shuffled_grouped_by_song.keys).limit(24).shuffle
    else
      @videos, @song, @songs = [], nil, []
    end
  end

  private

  def filtering_params
    params.permit(:dancer, :leader, :follower, :couple, :orchestra, :watched, :song, :channel, :event, :genre, :type).to_h
  end
end
