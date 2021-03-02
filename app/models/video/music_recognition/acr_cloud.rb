class Video::MusicRecognition::AcrCloud
  class << self
    def fetch(youtube_id)
      new(youtube_id).call
    end
  end

  def initialize(youtube_id)
    @youtube_id = youtube_id
    @video = Video.find_by(youtube_id: youtube_id)
    @video_attributes = video_attributes
  end

  def call
    byebug
    @video.update(video_params)
  end

  private

  def file_path
    Audio.import(@youtube_id)
  end

  def data
    Client.send_audio(file_path)
  end

  def video_attributes
    Parse.parse(data)
  end

  def video_params
    {
      acr_response_code:     @video_attributes.acr_response_code,
      spotify_album_id:      @video_attributes.spotify_album_id,
      spotify_album_name:    @video_attributes.spotify_album_id,
      spotify_artist_id:     @video_attributes.spotify_artist_id,
      spotify_artist_id_1:   @video_attributes.spotify_artist_id_1,
      spotify_artist_id_2:   @video_attributes.spotify_artist_id_2,
      spotify_artist_name:   @video_attributes.spotify_artist_name,
      spotify_artist_name_1: @video_attributes.spotify_artist_name_1,
      spotify_artist_name_2: @video_attributes.spotify_artist_name_2,
      spotify_track_id:      @video_attributes.spotify_track_id,
      spotify_track_name:    @video_attributes.spotify_track_name,
      youtube_song_id:       @video_attributes.youtube_song_id,
      isrc:                  @video_attributes.isrc
    }
  end
end
