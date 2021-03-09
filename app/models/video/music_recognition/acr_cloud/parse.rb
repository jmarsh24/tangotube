class Video::MusicRecognition::AcrCloud::Parse
  class << self
    def parse(acr_cloud_data)
      new(acr_cloud_data).parse_data_from_file
    end
  end

  attr_reader :acr_response_code,
              :spotify_album_id,
              :spotify_album_name,
              :spotify_artist_id,
              :spotify_artist_id_1,
              :spotify_artist_id_2,
              :spotify_artist_name,
              :spotify_artist_name_1,
              :spotify_artist_name_2,
              :spotify_track_id,
              :spotify_track_name,
              :youtube_song_id,
              :isrc

  def initialize(acr_cloud_data)
    @acr_cloud_data = acr_cloud_data
  end

  def parse_data_from_file
    parse_acr_cloud_data
    fetch_spotify_data
  end

  private

  def parse_acr_cloud_data
    @acr_response_code = parsed_acr_cloud_data.dig("status", "code")

    if parsed_acr_cloud_data.deep_find("spotify").present?
      @spotify_album_id      = parsed_acr_cloud_data.deep_find("spotify").dig("album", "id")
      @spotify_artist_id     = parsed_acr_cloud_data.deep_find("spotify").dig("artists", 0, "id")
      @spotify_artist_id_1   = parsed_acr_cloud_data.deep_find("spotify").dig("artists", 1, "id")
      @spotify_artist_id_2   = parsed_acr_cloud_data.deep_find("spotify").dig("artists", 2, "id")
      @spotify_track_id      = parsed_acr_cloud_data.deep_find("spotify").dig("track", "id")
    end

    @youtube_song_id       = parsed_acr_cloud_data.deep_find("youtube")["vid"] if parsed_acr_cloud_data.deep_find("youtube").present?
    @isrc                  = parsed_acr_cloud_data.deep_find("external_ids")["isrc"] if parsed_acr_cloud_data.deep_find("external_ids").present?
  end

  def fetch_spotify_data
    if parsed_acr_cloud_data.deep_find("spotify").present?
      @spotify_album_name    = RSpotify::Album.find(@spotify_album_id).name if @spotify_album_id.present?
      @spotify_artist_name   = RSpotify::Artist.find(@spotify_artist_id).name if @spotify_artist_id.present?
      @spotify_artist_name_1 = RSpotify::Artist.find(@spotify_artist_id_1).name if @spotify_artist_id_1.present?
      @spotify_artist_name_2 = RSpotify::Artist.find(@spotify_artist_id_2).name if @spotify_artist_id_2.present?
      @spotify_track_name    = RSpotify::Track.find(@spotify_track_id).name if @spotify_track_id.present?
    end
  end

  def parsed_acr_cloud_data
    @parsed_acr_cloud_data ||= JSON.parse(@acr_cloud_data).extend Hashie::Extensions::DeepFind
  end
end
