# frozen_string_literal: true

class MusicRecognizer
  def initialize(acr_cloud: AcrCloud.new, audio_trimmer: AudioTrimmer.new, youtube_audio_downloader: YoutubeAudioDownloader.new)
    @acr_cloud = acr_cloud
    @audio_trimmer = audio_trimmer
    @youtube_audio_downloader = youtube_audio_downloader
  end

  def process_audio_snippet(slug)
    @youtube_audio_downloader.download_file(slug) do |full_length_audio_file|
      @audio_trimmer.trim(full_length_audio_file) do |trimmed_audio_file|
        @data = @acr_cloud.analyze(trimmed_audio_file)
      end
    end

    MusicRecognitionMetadata.new(
      code:,
      message:,
      acr_song_title:,
      acr_artist_names:,
      acr_album_name:,
      acrid:,
      isrc:,
      genre:,
      spotify_artist_names:,
      spotify_track_name:,
      spotify_track_id:,
      spotify_album_name:,
      spotify_album_id:,
      youtube_vid:
    )
  end

  private

  def status
    @data.dig :status
  end

  def message
    status&.dig :msg
  end

  def code
    status&.dig :code
  end

  def music
    @data.dig :metadata, :music, 0
  end

  def external_metadata
    music&.dig :external_metadata
  end

  def acr_song_title
    music&.dig :title
  end

  def acr_artist_names
    music&.dig(:artists)&.map { |e| e[:name] }
  end

  def acr_album_name
    music&.dig :album, :name
  end

  def acrid
    music&.dig :acrid
  end

  def isrc
    music&.dig :external_ids, :isrc
  end

  def genre
    music&.dig :genres, 0, :name
  end

  def spotify
    return nil unless external_metadata
    external_metadata.dig(:spotify)
  end

  def spotify_artist_names
    spotify&.dig(:artists)&.map { |e| e[:name] }
  end

  def spotify_track_name
    spotify&.dig :track, :name
  end

  def spotify_album_name
    spotify&.dig :album, :name
  end

  def spotify_track_id
    spotify&.dig :track, :id
  end

  def spotify_album_id
    spotify&.dig :album, :id
  end

  def youtube_vid
    external_metadata&.dig :youtube, :vid
  end
end
