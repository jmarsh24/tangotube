# frozen_string_literal: true

class MusicRecognizer
  attr_reader :acr_cloud
  def initialize(audio_file:, acr_cloud: AcrCloud.new)
    @acr_cloud = acr_cloud
    @audio_file = audio_file
  end

  def process_audio_snippet(audio_file)
    data = acr_cloud.upload(audio_file)
    @data = JSON.parse(data, symbolize_names: true)

    MusicRecognitionMetadata.new(
      code:,
      message:,
      acr_title:,
      acr_album_name:,
      acrid:,
      isrc:,
      genre:,
      spotify_artist_names:,
      spotify_track_name:,
      spotify_album_name:,
      youtube_vid:
    )
  end

  private

  def status
    @data.dig :status
  end

  def message
    status.dig :msg
  end

  def code
    status.dig :code
  end

  def music
    @data.dig :metadata, :music, 0
  end

  def external_metadata
    music.dig :external_metadata
  end

  def acr_title
    music.dig :title
  end

  def acr_album_name
    music.dig :album, :name
  end

  def acrid
    music.dig :acrid
  end

  def isrc
    music.dig :external_ids, :isrc
  end

  def genre
    music.dig :genres, 0, :name
  end

  def spotify
    external_metadata.dig(:spotify)
  end

  def spotify_artist_names
    return if spotify.nil?
    spotify.dig(:artists).map { |e| e[:name] }
  end

  def spotify_track_name
    return if spotify.nil?
    spotify.dig :track, :name
  end

  def spotify_album_name
    return if spotify.nil?
    spotify.dig :album, :name
  end

  def spotify_track_id
    return if spotify.nil?
    spotify.dig :track, :id
  end

  def youtube_vid
    external_metadata.dig :youtube, :vid
  end
end
