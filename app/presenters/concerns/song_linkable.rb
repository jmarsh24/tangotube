# frozen_string_literal: true

module SongLinkable
  def song_link
    if song.present?
      link_to song.full_title, root_path(song: song.slug)
    elsif external_song_attributes.present?
      link_to external_song_attributes, root_path(query: song_query_param)
    end
  end

  private

  def song_query_param
    external_song_attributes.gsub(/\s-\s/, " ")
  end

  def format_song_attributes(title, artist, genre = nil)
    formatted_title = title&.titleize
    formatted_artist = titleize_artist_name(artist)
    genre.present? ? "#{formatted_title} - #{formatted_artist} - #{genre.titleize}" : "#{formatted_title} - #{formatted_artist}"
  end

  def titleize_artist_name(artist_name)
    artist_name&.split("'")&.map(&:titleize)&.join("'")
  end

  def external_song_attributes
    acr_cloud_song_attributes || spotify_song_attributes || youtube_song_attributes
  end

  def acr_cloud_song_attributes
    return if metadata.music.acr_song_title.blank? || metadata.music.acr_artist_names.blank?

    format_song_attributes(
      metadata.music.acr_song_title,
      titleize_artist_name(metadata.music.acr_artist_names),
      metadata.music.genre&.titleize
    )
  end

  def spotify_song_attributes
    return if metadata.music.spotify_track_name.blank? || metadata.music.spotify_artist_names.blank?

    format_song_attributes(
      metadata.music.spotify_track_name,
      titleize_artist_name(metadata.music.spotify_artist_names.first),
      metadata.music.genre&.titleize
    )
  end

  def youtube_song_attributes
    return if metadata.music.youtube.song.titles.blank? || metadata.music.youtube.song.artist.blank?

    format_song_attributes(
      metadata.music.youtube.song.titles.first,
      titleize_artist_name(metadata.music.youtube.song.artist),
      metadata.music.genre&.titleize
    )
  end
end
