# frozen_string_literal: true

class Video::Display
  def initialize(video)
    @video = video
  end

  def display
    @display ||= Video::Display.new(self)
  end

  def any_song_attributes
    el_recodo_attributes || spotify_attributes || youtube_attributes ||
      acr_cloud_attributes
  end

  def external_song_attributes
    spotify_attributes || youtube_attributes || acr_cloud_attributes
  end

  def el_recodo_attributes
    return if @video.metadata.youtube.song.titles.blank?

    format_song_attributes(
      @video.metadata.youtube.song.titles.first,
      @video.metadata.youtube.song.artist
    )
  end

  def spotify_attributes
    return if @video.metadata.music.spotify_track_name.blank? || @video.metadata.music.spotify_artist_names.blank?

    format_song_attributes(
      @video.metadata.music.spotify_track_name,
      @video.metadata.music.spotify_artist_names.first
    )
  end

  def youtube_attributes
    return if @video.metadata.youtube.song.titles.blank? || @video.metadata.youtube.song.artist.blank?

    format_song_attributes(
      @video.metadata.youtube.song.titles.first,
      @video.metadata.youtube.song.artist
    )
  end

  def acr_cloud_attributes
    return if @video.metadata.music.acr_song_title.blank? || @video.metadata.music.acr_artist_names.blank?

    format_song_attributes(
      @video.metadata.music.acr_song_title,
      @video.metadata.music.acr_artist_names.first
    )
  end

  def dancer_names
    return if @video.dancers.empty?

    dancer_names_array = @video.dancers.map(&:name)
    dancer_names_array.join(" & ")
  end

  private

  def format_song_attributes(title, artist, genre = nil)
    formatted_title = title&.titleize
    formatted_artist = titleize_artist_name(artist)
    if genre.nil?
      "#{formatted_title} - #{formatted_artist}"
    else
      "#{formatted_title} - #{formatted_artist} - #{genre.titleize}"
    end
  end

  def titleize_artist_name(artist_name)
    return "" if artist_name.nil?

    artist_name.split("'").map(&:titleize).join("'")
  end
end
