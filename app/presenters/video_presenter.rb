# frozen_string_literal: true

class VideoPresenter < SimpleDelegator
  include ActionView::Helpers::NumberHelper

  def hd_duration_data
    duration = metadata.youtube.duration
    return if duration.blank?

    hd_suffix = metadata.youtube.hd? ? "HD " : ""
    Time.at(duration).utc.strftime("#{hd_suffix}%M:%S")
  end

  def meta_title
    dancers.present? ? dancer_names : title
  end

  def meta_description
    song&.full_title || external_song_attributes
  end

  def display_metadata
    formatted_like_count = formatted_count(youtube_like_count)
    formatted_view_count = formatted_count(youtube_view_count)
    "#{formatted_upload_date} • #{formatted_view_count} views • #{formatted_like_count} likes"
  end

  def performance_number
    "#{performance_video.position} / #{performance.videos_count}" if performance.present?
  end

  private

  def song_query_param
    external_song_attributes.gsub(/\s-\s/, " ")
  end

  def formatted_count(count)
    number_to_human(count, format: "%n%u", precision: 2, units: {thousand: "K", million: "M", billion: "B"})
  end

  def formatted_upload_date
    return if upload_date.nil?

    begin
      date = upload_date.is_a?(Date) ? upload_date : Date.parse(upload_date)
      date.strftime("%B, %Y")
    rescue ArgumentError
      "Invalid date"
    end
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
    return unless metadata.music.acr_song_title.present? && metadata.music.acr_artist_names.present?

    format_song_attributes(
      metadata.music.acr_song_title,
      titleize_artist_name(metadata.music.acr_artist_names.first),
      metadata.music.genre&.titleize
    )
  end

  def spotify_song_attributes
    return unless metadata.music.spotify_track_name.present? && metadata.music.spotify_artist_names.present?

    format_song_attributes(
      metadata.music.spotify_track_name,
      titleize_artist_name(metadata.music.spotify_artist_names.first),
      metadata.music.genre&.titleize
    )
  end

  def youtube_song_attributes
    return unless metadata.youtube.song.titles.present? && metadata.youtube.song.artist.present?

    format_song_attributes(
      metadata.youtube.song.titles.first,
      titleize_artist_name(metadata.youtube.song.artist),
      metadata.music.genre&.titleize
    )
  end

  def external_song_attributes
    acr_cloud_song_attributes || spotify_song_attributes || youtube_song_attributes
  end

  def dancer_names
    @dancer_names ||= dancers.map(&:full_name).join(" & ")
  end
end
