module Displayable
  extend ActiveSupport::Concern

  def any_song_attributes
    el_recodo_attributes || spotify_attributes || youtube_attributes || acr_cloud_attributes
  end

  def external_song_attributes
    spotify_attributes || youtube_attributes || acr_cloud_attributes
  end

  def el_recodo_attributes
    return if song.blank?

    [song.title, song.artist, song.genre].compact.map(&:titleize).join(" - ")
  end

  def spotify_attributes
    return if spotify_track_name.blank? || spotify_artist_name.blank?

    [spotify_track_name, spotify_artist_name].compact.map(&:titleize).join(" - ")
  end

  def youtube_attributes
    return if youtube_song.blank? || youtube_artist.blank?

    [youtube_song, youtube_artist].compact.map(&:titleize).join(" - ")
  end

  def acr_cloud_attributes
    return if acr_cloud_track_name.blank? || acr_cloud_artist_name.blank?

    [acr_cloud_track_name, acr_cloud_artist_name].compact.map(&:titleize).join(" - ")
  end

  def dancer_names
    return if leader.blank? || follower.blank?

    [leader.name, follower.name].compact.map(&:titleize).join(" & ")
  end
end
