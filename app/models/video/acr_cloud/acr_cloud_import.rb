class Video::AcrCloud::AcrCloudImport
  class << self
    # accepts file path and submits a http request to ACR Cloud API
    def acr_sound_match(file_path)
      requrl = "http://identify-eu-west-1.acrcloud.com/v1/identify"
      access_key = ENV["ACRCLOUD_ACCESS_KEY"]
      access_secret = ENV["ACRCLOUD_SECRET_KEY"]

      http_method = "POST"
      http_uri = "/v1/identify"
      data_type = "audio"
      signature_version = "1"
      timestamp = Time.now.utc.to_i.to_s

      string_to_sign = http_method + "\n" + http_uri + "\n" + access_key + "\n" + data_type + "\n" + signature_version + "\n" + timestamp

      digest = OpenSSL::Digest.new("sha1")
      signature = Base64.encode64(OpenSSL::HMAC.digest(digest, access_secret, string_to_sign))

      sample_bytes = File.size(file_path)

      url = URI.parse(requrl)
      File.open(file_path) do |file|
        req = Net::HTTP::Post::Multipart.new url.path,
                                             "sample"            => UploadIO.new(file, "audio/mp3", file_path),
                                             "access_key"        => access_key,
                                             "data_type"         => data_type,
                                             "signature_version" => signature_version,
                                             "signature"         => signature,
                                             "sample_bytes"      => sample_bytes,
                                             "timestamp"         => timestamp
        res = Net::HTTP.start(url.host, url.port) do |http|
          http.request(req)
        end
        body = res.body.force_encoding("utf-8")
        body
      end
    end

    # Parse response spotify, youtube, and isrc information from ACR_sound_match
    def parse_acr_response(acr_response_body, youtube_id)
      youtube_video = Video.find_by(youtube_id: youtube_id)
      video = JSON.parse(acr_response_body).extend Hashie::Extensions::DeepFind

      if video["status"]["code"] == 0

        if video.deep_find("spotify")["album"].present?
          if video.deep_find("spotify")["album"]["id"].present?
            spotify_album_id = video.deep_find("spotify")["album"]["id"]
          end
          if video.deep_find("spotify")["album"]["name"].present?
            spotify_album_name = video.deep_find("spotify")["album"]["name"]
          end
          if video.deep_find("spotify")["album"]["id"].present?
            spotify_album_name = RSpotify::Album.find(spotify_album_id).name
          end
        end

        if video.deep_find("spotify")["artists"][0].present?
          if video.deep_find("spotify")["artists"][0]["id"].present?
            spotify_artist_id = video.deep_find("spotify")["artists"][0]["id"]
          end
          if video.deep_find("spotify")["artists"][0]["name"].present?
            spotify_artist_name = video.deep_find("spotify")["artists"][0]["name"]
          end
          if video.deep_find("spotify")["artists"][1].present?
            spotify_artist_id_2 = video.deep_find("spotify")["artists"][1]["id"]
          end
          spotify_artist_name = RSpotify::Artist.find(spotify_artist_id).name if spotify_artist_id.present?
          spotify_artist_name_2 = RSpotify::Artist.find(spotify_artist_id_2).name if spotify_artist_id_2.present?
        end

        if video.deep_find("spotify")["track"].present? && video.deep_find("spotify")["track"]["id"].present?
          spotify_track_id = video.deep_find("spotify")["track"]["id"]
          spotify_track_name = video.deep_find("spotify")["track"]["name"]
          spotify_track_name = RSpotify::Track.find(spotify_track_id).name
        end
        youtube_song_id = video.deep_find("youtube")["vid"] if video.deep_find("youtube").present?

        isrc = video.deep_find("external_ids")["isrc"] if video.deep_find("external_ids")["isrc"].present?
        youtube_video.update(
          spotify_album_id:      spotify_album_id,
          spotify_album_name:    spotify_album_name,
          spotify_artist_id:     spotify_artist_id,
          spotify_artist_name:   spotify_artist_name,
          spotify_artist_id_2:   spotify_artist_id_2,
          spotify_artist_name_2: spotify_artist_name_2,
          spotify_track_id:      spotify_track_id,
          spotify_track_name:    spotify_track_name,
          youtube_song_id:       youtube_song_id,
          isrc:                  isrc,
          acr_response_code:     video["status"]["code"]
        )

      else
        youtube_video.update(
          acr_response_code: video["status"]["code"]
        )
      end
    rescue Module
    rescue RestClient::Exceptions::OpenTimeout
    rescue FFMPEG::Error
    rescue Errno::ENOENT
    rescue StandardError
    end

    def acr_music_match(youtube_id)
      video = Video.find_by(youtube_id: youtube_id)
      clipped_audio = Video.clip_audio(youtube_id)
      acr_response_body = Video.acr_sound_match(clipped_audio)
      Video.parse_acr_response(acr_response_body, youtube_id)
    end

    # Generates audio clip from youtube_id and outputs file path
    def clip_audio(youtube_id)
      video = Video.find_by(youtube_id: youtube_id)
      audio_full = YoutubeDL.download(
        "https://www.youtube.com/watch?v=#{video.youtube_id}",
        { format: "140", output: "~/environment/data/audio/%(id)s.mp3" }
      )

      song = FFMPEG::Movie.new(audio_full.filename.to_s)

      time_1 = audio_full.duration / 2
      time_2 = time_1 + 20

      output_file_path = audio_full.filename.gsub(/.mp3/, "_#{time_1}_#{time_2}.mp3")

      song_transcoded = song.transcode(output_file_path,
                                       { custom: %W[-ss #{time_1} -to #{time_2}] })
      output_file_path
    end
end
end
