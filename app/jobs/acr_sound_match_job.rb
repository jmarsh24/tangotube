class AcrSoundMatchJob < ApplicationJob
  queue_as :default

  def perform
    Video.where(acr_response_code: nil).each do |youtube_video|
      youtube_audio_full = YoutubeDL.download(
                            "https://www.youtube.com/watch?v=#{youtube_video.youtube_id}",
                            {format: "140", output: "~/environment/data/audio/%(id)s.wav"}
                            )

      song = FFMPEG::Movie.new(youtube_audio_full.filename.to_s)

      time_1 = youtube_audio_full.duration / 2
      time_2 = time_1 + 20

      output_file_path = youtube_audio_full.filename.gsub(/.wav/, "_#{time_1}_#{time_2}.wav")

      song_transcoded = song.transcode(output_file_path,
        {audio_codec: "pcm_s16le",
          audio_channels: 1,
          audio_bitrate: 16,
          audio_sample_rate: 16000,
          custom: %W[-ss #{time_1} -to #{time_2}]})

      song_match_output = acrcloud_match(output_file_path)

      puts ap JSON.parse song_match_output

      video = JSON.parse(song_match_output).extend Hashie::Extensions::DeepFind

      if video["status"]["code"] == 0 && video.deep_find("spotify").present?

        spotify_album_id = video.deep_find("spotify")["album"]["id"] if video.deep_find("spotify")["album"].present?
        spotify_album_name = RSpotify::Album.find(spotify_album_id).name if video.deep_find("spotify")["album"]["id"].present?
        spotify_artist_id = video.deep_find("spotify")["artists"][0]["id"] if video.deep_find("spotify")["artists"][0].present?
        spotify_artist_name = RSpotify::Artist.find(spotify_artist_id).name if video.deep_find("spotify")["artists"][0]["id"].present?
        spotify_artist_id_2 = video.deep_find("spotify")["artists"][1]["id"] if video.deep_find("spotify")["artists"][1].present?
        spotify_artist_id_3 = video.deep_find("spotify")["artists"][2]["id"] if video.deep_find("spotify")["artists"][2].present?
        spotify_artist_name_2 = RSpotify::Artist.find(spotify_artist_id_2).name if video.deep_find("spotify")["artists"][1]["id"].present?
        spotify_track_id = video.deep_find("spotify")["track"]["id"] if video.deep_find("spotify")["track"]["id"].present?
        spotify_track_name = RSpotify::Track.find(spotify_track_id).name if video.deep_find("spotify")["track"]["id"].present?
        youtube_song_id = video.deep_find("youtube")["vid"] if video.deep_find("youtube").present?
        isrc = video.deep_find("external_ids")["isrc"] if video.deep_find("external_ids")["isrc"].present?

        youtube_video.update(
          spotify_album_id: spotify_album_id,
          spotify_album_name: spotify_album_name,
          spotify_artist_id: spotify_artist_id,
          spotify_artist_name: spotify_artist_name,
          spotify_artist_id_2: spotify_artist_id_2,
          spotify_artist_name_2: spotify_artist_name_2,
          spotify_track_id: spotify_track_id,
          spotify_track_name: spotify_track_name,
          youtube_song_id: youtube_song_id,
          isrc: isrc,
          acr_response_code: video["status"]["code"]
        )

      elsif video["status"]["code"] == 0 && video.deep_find("external_ids")["isrc"].present?
        youtube_video.update(
        acr_response_code: video["status"]["code"],
        isrc: video.deep_find("external_ids")["isrc"]
        )

      else
        youtube_video.update(
          acr_response_code: video["status"]["code"]
        )
      end
    rescue Terrapin::ExitStatusError
    rescue RestClient::Exceptions::OpenTimeout
    end
  end

  def acrcloud_match(file_name)
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

    sample_bytes = File.size(file_name)

    url = URI.parse(requrl)
    File.open(file_name) do |file|
      req = Net::HTTP::Post::Multipart.new url.path,
        "sample" => UploadIO.new(file, "audio/mp3", file_name),
        "access_key" => access_key,
        "data_type" => data_type,
        "signature_version" => signature_version,
        "signature" => signature,
        "sample_bytes" => sample_bytes,
        "timestamp" => timestamp
      res = Net::HTTP.start(url.host, url.port) { |http|
        http.request(req)
      }
      body = res.body.force_encoding("utf-8")
      body
    end
  end
end
