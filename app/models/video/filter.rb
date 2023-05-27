class Video::Filter
  attr_reader :video_relation, :filtering_params

  def initialize(video_relation, filtering_params: {})
    @video_relation = video_relation
    @filtering_params = filtering_params
  end

  def apply_filter
    filtered_videos
  end

  private

  def filtered_videos
    return video_relation if filtering_params.blank?

    filtered = video_relation
    filtering_params.each do |key, value|
      filtered = send("apply_#{key}_filter", filtered, value) if value.present?
    end
    filtered
  end

  def apply_leader_filter(videos, value)
    videos
      .joins(:dancer_videos)
      .joins("JOIN dancers ON dancers.id = dancer_videos.dancer_id")
      .where(dancers: {slug: value})
      .where(dancer_videos: {role: "leader"})
  end

  def apply_follower_filter(videos, value)
    videos
      .joins(:dancer_videos)
      .joins("JOIN dancers ON dancers.id = dancer_videos.dancer_id")
      .where(dancers: {slug: value})
      .where(dancer_videos: {role: "follower"})
  end

  def apply_orchestras_filter(videos, value)
    videos.joins(:song, :orchestra).where(orchestras: {slug: value})
  end

  def apply_genre_filter(videos, value)
    videos.joins(:song).where("LOWER(songs.genre) = ?", value.downcase)
  end

  def apply_year_filter(videos, value)
    videos.where(upload_date_year: value)
  end

  def apply_song_filter(videos, value)
    videos.joins(:song).where(songs: {slug: value})
  end
end
