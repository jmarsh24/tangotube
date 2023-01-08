# frozen_string_literal: true

class Video::MusicRecognition::AcrCloud
  class << self
    def fetch(youtube_id)
      new(youtube_id).update_video
    rescue => e
      Rails.logger.warn "Video::MusicRecognition::AcrCloud no video found: #{e}\n\t#{e.backtrace.join("\n\t")}"
    end
  end

  def initialize(youtube_id)
    @youtube_id = youtube_id
    @video = Video.find_by(youtube_id:)
  end

  def update_video
    @video.update(video_params)
  end

  private

  def acr_cloud_response
    Tempfile.create([@youtube_id, ".mp3"]) do |tempfile1|
      Audio.import(@youtube_id, tempfile1.path)
      Tempfile.create(["#{@youtube_id}_from_60_to_75", ".mp3"]) do |tempfile2|
        audio_file = transcode_audio_file(tempfile1.path, tempfile2.path)
        @acr_cloud_response ||= Client.send_audio(audio_file.path)
      end
    end
  end

  def transcode_audio_file(input_file_path, output_file_path)
    audio_file = FFMPEG::Movie.new(input_file_path)
    start_time = audio_file.duration / 2
    end_time = start_time + 20
    audio_file.transcode(output_file_path, {custom: %W[-y -ss #{start_time} -to #{end_time}]})
  end

  def video_params
    {
      acr_response_code:,
      spotify_album_id:,
      spotify_album_name:,
      spotify_artist_id:,
      spotify_artist_id_1:,
      spotify_artist_id_2:,
      spotify_artist_name:,
      spotify_artist_name_1:,
      spotify_artist_name_2:,
      spotify_track_id:,
      spotify_track_name:,
      acr_cloud_artist_name:,
      acr_cloud_artist_name_1:,
      acr_cloud_album_name:,
      acr_cloud_track_name:,
      youtube_song_id:,
      acrid:,
      isrc:
    }
  end

  def acr_response_code
    return if parsed_acr_cloud_data.dig("status", "code").blank?

    @acr_response_code ||= parsed_acr_cloud_data.dig("status", "code")
  end

  def youtube_song_id
    return if parsed_acr_cloud_data.deep_find("youtube").blank?

    @youtube_song_id ||= parsed_acr_cloud_data.deep_find("youtube")["vid"]
  end

  def isrc
    return if parsed_acr_cloud_data.deep_find("external_ids").blank?

    @isrc ||= parsed_acr_cloud_data.deep_find("external_ids")["isrc"]
  end

  def spotify_params
    return if parsed_acr_cloud_data.deep_find("spotify").blank?

    @spotify_params ||= parsed_acr_cloud_data.deep_find("spotify")
  end

  def spotify_album_id
    return if spotify_params.blank?

    @spotify_album_id ||= spotify_params.dig("album", "id")
  end

  def spotify_artist_id
    return if spotify_params.blank?

    @spotify_artist_id ||= spotify_params.dig("artists", 0, "id")
  end

  def spotify_artist_id_1
    return if spotify_params.blank?

    @spotify_artist_id_1 ||= spotify_params.dig("artists", 1, "id")
  end

  def spotify_artist_id_2
    return if spotify_params.blank?

    @spotify_artist_id_2 ||= spotify_params.dig("artists", 2, "id")
  end

  def spotify_track_id
    return if spotify_params.blank?

    @spotify_track_id ||= spotify_params.dig("track", "id")
  end

  def spotify_album_name
    return if spotify_album_id.blank?

    @spotify_album_name ||= RSpotify::Album.find(@spotify_album_id).name
  end

  def spotify_artist_name
    return if spotify_artist_id.blank?

    @spotify_artist_name ||= RSpotify::Artist.find(@spotify_artist_id).name
  end

  def spotify_artist_name_1
    return if spotify_artist_id_1.blank?

    @spotify_artist_name_1 ||= RSpotify::Artist.find(@spotify_artist_id_1).name
  end

  def spotify_artist_name_2
    return if @spotify_artist_id_2.blank?

    @spotify_artist_name_2 ||= RSpotify::Artist.find(@spotify_artist_id_2).name
  end

  def spotify_track_name
    return if @spotify_track_id.blank?

    @spotify_track_name ||= RSpotify::Track.find(@spotify_track_id).name
  end

  def acr_cloud_artists
    return if parsed_acr_cloud_data.deep_find("artists").blank?

    parsed_acr_cloud_data.deep_find("artists")
  end

  def acr_cloud_artist_name
    return if acr_cloud_artists.blank?

    acr_cloud_artists.dig(0, "name")
  end

  def acr_cloud_artist_name_1
    return if acr_cloud_artists.blank?

    acr_cloud_artists.dig(1, "name")
  end

  def acr_cloud_album_name
    return if parsed_acr_cloud_data.deep_find("album").blank?

    parsed_acr_cloud_data.deep_find("album")["name"]
  end

  def acr_cloud_track_name
    return if parsed_acr_cloud_data.deep_find("title").blank?

    parsed_acr_cloud_data.deep_find("title")
  end

  def acrid
    return if parsed_acr_cloud_data.deep_find("acrid").blank?

    parsed_acr_cloud_data.deep_find("acrid")
  end

  def parsed_acr_cloud_data
    @parsed_acr_cloud_data ||= JSON.parse(acr_cloud_response).extend Hashie::Extensions::DeepFind
  end
end
