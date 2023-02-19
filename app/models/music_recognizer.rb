class MusicRecognizer
  attr_reader :music_data

  def self.process(sound_file:)
    new(sound_file).process
  end

  def initialize(sound_file)
    @sound_file = sound_file
  end

  def process
    music_data ||=
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
    if successful_acr_match?
      music_data.as_json
    else
      "failure"
    end
  end

  private

  def successful_acr_match?
    acr_data["status"]["msg"] == "Success"
  end

  def spotify_params
    return if acr_data.deep_find("spotify").blank?

    @spotify_params ||= acr_data.deep_find "spotify"
  end

  def acr_response_code
    return if acr_data.dig("status", "code").blank?

    @acr_data_code ||= acr_data.dig("status", "code")
  end

  def youtube_song_id
    return if acr_data.deep_find("youtube").blank?

    @youtube_song_id ||= acr_data.deep_find("youtube")["vid"]
  end

  def isrc
    return if acr_data.deep_find("external_ids").blank?

    @isrc ||= acr_data.deep_find("external_ids")["isrc"]
  end

  def spotify_album_id
    return if spotify_params.blank?

    @spotify_album_id ||= spotify_params.dig "album", "id"
  end

  def spotify_artist_id
    return if spotify_params.blank?

    @spotify_artist_id ||= spotify_params.dig "artists", 0, "id"
  end

  def spotify_artist_id_1
    return if spotify_params.blank?

    @spotify_artist_id_1 ||= spotify_params.dig "artists", 1, "id"
  end

  def spotify_artist_id_2
    return if spotify_params.blank?

    @spotify_artist_id_2 ||= spotify_params.dig "artists", 2, "id"
  end

  def spotify_track_id
    return if spotify_params.blank?

    @spotify_track_id ||= spotify_params.dig "track", "id"
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
    return if acr_data.deep_find("artists").blank?

    acr_data.deep_find "artists"
  end

  def acr_cloud_artist_name
    return if acr_cloud_artists.blank?

    acr_cloud_artists.dig 0, "name"
  end

  def acr_cloud_artist_name_1
    return if acr_cloud_artists.blank?

    acr_cloud_artists.dig 1, "name"
  end

  def acr_cloud_album_name
    return if acr_data.deep_find("album").blank?

    acr_data.deep_find("album")["name"]
  end

  def acr_cloud_track_name
    return if acr_data.deep_find("title").blank?

    acr_data.deep_find "title"
  end

  def acrid
    return if acr_data.deep_find("acrid").blank?

    acr_data.deep_find "acrid"
  end

  def spotify_track_id
    return if spotify_params.blank?

    spotify_params.dig "track", "id"
  end

  def acr_data
    @acr_data ||= AcrCloud.send(sound_file: @sound_file).data.extend Hashie::Extensions::DeepFind
  end
end
