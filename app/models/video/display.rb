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
    return if @video.song.blank?
    format_song_attributes(@video.song.title, @video.song.artist, @video.song.genre)
  end

  def spotify_attributes
    return if @video.spotify_track_name.blank? || @video.spotify_artist_name.blank?
    format_song_attributes(@video.spotify_track_name, @video.spotify_artist_name)
  end

  def youtube_attributes
    return if @video.youtube_song.blank? || @video.youtube_artist.blank?
    format_song_attributes(@video.youtube_song, @video.youtube_artist)
  end

  def acr_cloud_attributes
    return if @video.acr_cloud_track_name.blank? || @video.acr_cloud_artist_name.blank?
    format_song_attributes(@video.acr_cloud_track_name, @video.acr_cloud_artist_name)
  end

  def dancer_names
    return if @video.dancers.empty?
    dancer_names_array = @video.dancers.map(&:name)
    dancer_names_array.join(" & ")
  end

  private

  def format_song_attributes(title, artist, genre = nil)
    formatted_title = title.titleize
    formatted_artist = titleize_artist_name(artist)
    if genre.nil?
      "#{formatted_title} - #{formatted_artist}"
    else
      "#{formatted_title} - #{formatted_artist} - #{genre.titleize}"
    end
  end

  def titleize_artist_name(artist_name)
    artist_name.split("'").map(&:titleize).join("'")
  end
end
