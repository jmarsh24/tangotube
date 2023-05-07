# frozen_string_literal: true

module MetaDataDisplayable
  def display_metadata
    formatted_like_count = formatted_count(metadata.youtube.like_count)
    formatted_view_count = formatted_count(metadata.youtube.view_count)
    "#{formatted_performance_date} • #{formatted_view_count} views • #{formatted_like_count} likes"
  end

  def meta_title
    dancers.present? ? dancer_names : metadata.youtube.title
  end

  def meta_description
    song&.full_title || external_song_attributes
  end

  private

  def external_song_attributes
    acr_cloud_song_attributes || spotify_song_attributes || youtube_song_attributes
  end

  def formatted_count(count)
    number_to_human(
      count,
      format: "%n%u",
      precision: 2,
      units: {
        thousand: "K",
        million: "M",
        billion: "B"
      }
    )
  end

  def formatted_performance_date
    metadata.youtube.upload_date.strftime("%B %Y")
  end

  def format_song_attributes(title, artist, genre = nil)
    formatted_title = title&.titleize
    formatted_artist = titleize_artist_name(artist)
    genre.present? ? "#{formatted_title} - #{formatted_artist} - #{genre.titleize}" : "#{formatted_title} - #{formatted_artist}"
  end

  def titleize_artist_name(artist_name)
    artist_name&.split("'")&.map(&:titleize)&.join("'")
  end

  def acr_cloud_song_attributes
    return if metadata.music.acr_song_title.blank? || metadata.music.acr_artist_names.blank?

    format_song_attributes(
      metadata.music.acr_song_title,
      titleize_artist_name(metadata.music.acr_artist_names.first),
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
    return if metadata.youtube.song.titles.blank? || metadata.youtube.song.artist.blank?

    format_song_attributes(
      metadata.youtube.song.titles.first,
      titleize_artist_name(metadata.youtube.song.artist),
      metadata.music.genre&.titleize
    )
  end
end
