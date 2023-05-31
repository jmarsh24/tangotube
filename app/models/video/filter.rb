class Video::Filter
  attr_reader :video_relation, :filtering_params, :current_user

  FILTER_METHODS = {
    liked_by_user: :apply_liked_by_user_filter,
    watched_by_user: :apply_watched_by_user_filter,
    leader: :apply_leader_filter,
    follower: :apply_follower_filter,
    orchestra: :apply_orchestra_filter,
    genre: :apply_genre_filter,
    year: :apply_year_filter,
    song: :apply_song_filter,
    event: :apply_event_filter,
    hidden: :apply_hidden_filter,
    channel: :apply_channel_filter,
    exclude_youtube_id: :apply_exclude_youtube_id_filter,
    hd: :apply_hd_filter,
    dancer: :apply_dancer_filter
  }.freeze

  def initialize(video_relation, filtering_params: {}, current_user: nil, hidden: false)
    @video_relation = video_relation
    @filtering_params = filtering_params
    @current_user = current_user
  end

  def apply_filter
    filtered_videos
  end

  private

  def filtered_videos
    return video_relation if filtering_params.blank?

    filtered = video_relation
    filtering_params.each do |key, value|
      next unless value.present?

      filtered = if key == :liked_by_user
        apply_liked_by_user_filter(filtered, current_user)
      elsif key == :watched_by_user
        apply_watched_by_user_filter(filtered, current_user)
      else
        send("apply_#{key}_filter", filtered, value)
      end
  end
    filtered
  end

  def apply_hd_filter(videos, value)
    videos.where("hd = ?", value)
  end

  def apply_dancer_filter(videos, value)
    if value
      videos.joins(:dancer_videos, :dancers)
    else
      videos.where.not(id: DancerVideo.select(:video_id))
    end
  end

  def apply_liked_by_user_filter(videos, user)
    return videos unless user

    videos.where(id: user.find_up_voted_items.pluck(:id))
  end

  def apply_watched_by_user_filter(videos, user)
    return videos unless user

    watched_video_ids = user.votes.where(vote_scope: "watchlist", vote_flag: true).pluck(:votable_id)

    videos.where(id: watched_video_ids)
  end

  def apply_leader_filter(videos, value)
    videos
      .joins("JOIN dancer_videos AS leader_dancer_videos ON leader_dancer_videos.video_id = videos.id")
      .joins("JOIN dancers AS leader_dancers ON leader_dancers.id = leader_dancer_videos.dancer_id")
      .where(leader_dancers: {slug: value}, leader_dancer_videos: {role: "leader"})
  end

  def apply_follower_filter(videos, value)
    videos
      .joins("JOIN dancer_videos AS follower_dancer_videos ON follower_dancer_videos.video_id = videos.id")
      .joins("JOIN dancers AS follower_dancers ON follower_dancers.id = follower_dancer_videos.dancer_id")
      .where(follower_dancers: {slug: value}, follower_dancer_videos: {role: "follower"})
  end

  def apply_orchestra_filter(videos, value)
    videos.joins(:song, :orchestra).where(orchestras: {slug: value})
  end

  def apply_event_filter(videos, value)
    videos.joins(:event).where(events: {slug: value})
  end

  def apply_genre_filter(videos, value)
    videos.joins(:song).where("LOWER(songs.genre) = ?", value.downcase)
  end

  def apply_channel_filter(videos, value)
    videos.joins(:channel).where(channels: {channel_id: value})
  end

  def apply_year_filter(videos, value)
    videos.where(upload_date_year: value)
  end

  def apply_song_filter(videos, value)
    videos.joins(:song).where(songs: {slug: value})
  end

  def apply_hidden_filter(videos, value)
    return videos if value == false
    videos.where(hidden: value)
  end

  def apply_exclude_youtube_id_filter(videos, value)
    videos.where.not(youtube_id: value)
  end
end
