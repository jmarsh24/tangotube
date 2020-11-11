
#Matches Song AND Artist with Video description

  Song.all.each do |song|
    Video.where( "unaccent(description) ILIKE unaccent(?) AND unaccent(description) ILIKE unaccent(?) ", "%#{song.title}%", "%#{song.artist.split.last}%").each do |video|
      if video.song.nil?
      video.song = song
      video.save
      end
    end
  end

  #Matches Event with Video description

  Event.all.each do |event|
    Video.where( "unaccent(description) ILIKE unaccent(?)", "%#{event.name}%").each do |video|
      video.event = event
      video.save
    end
    puts Video.pluck(:event_id).count
  end

    #Matches Event with Video title

   Event.all.each do |event|
    Video.where( "unaccent(title) ILIKE unaccent(?)", "%#{event.name}%").each do |video|
      video.event = event
      video.save
    end
    puts "#{Event.count} matches"
   end

    #Matches Videotype with Video title
    Videotype.all.each do |videotype|
      Video.where(videotype_id: nil).where( "unaccent(title) ILIKE unaccent(?)", "% #{videotype.name} %").each do |video|
        video.videotype = videotype
        video.save
      end
    end

    #Matches Videotype with Video description

    Videotype.all.each do |videotype|
      Video.where(videotype_id: nil).where( "unaccent(description) ILIKE unaccent(?)", "% #{videotype.name} %").each do |video|
        video.videotype = videotype
        video.save
      end
    end



  #SQL match for Follower
  Follower.all.each do |follower|
    Video.all.where(follower_id: nil).where( "unaccent(description) ILIKE unaccent(?)", "%#{follower.name}%").each do |video|
      video.follower = follower
      video.save
    end
    puts Video.pluck(:follower_id).count
  end

    #SQL match for Follower
    Follower.all.each do |follower|
      Video.all.where(follower_id: nil).where( "unaccent(tags) ILIKE unaccent(?)", "%#{follower.name}%").each do |video|
        video.follower = follower
        video.save
      end
    end

    #SQL match for Leader
    Leader.all.each do |leader|
      Video.all.where(leader_id: nil).where( "unaccent(tags) ILIKE unaccent(?)", "%#{leader.name}%").each do |video|
        video.leader = leader
        video.save
      end
    end


  Leader.all.each do |leader|
    Video.all.where(leader_id: nil).where( "unaccent(description) ILIKE unaccent(?)", "%#{leader.name}%").each do |video|
      video.leader = leader
      video.save
    end
  end

    #SQL match for Leader using fuzzystrmatch
    Leader.all.each do |leader|
      Video.where(leader_id: nil).where( "levenshtein(unaccent(title), unaccent(?) ) < 4 ", leader.name).each do |video|
        video.leader = leader
        video.save
      end
    end

        #SQL match for Leader using fuzzystrmatch
        Leader.all.each do |leader|
          Video.where(leader_id: nil).where( "levenshtein(unaccent(description), unaccent(?) ) < 4 ", leader.name).each do |video|
            video.leader = leader
            video.save
          end
        end

    Follower.all.each do |follower|
      Video.where(follower_id: nil).where( "levenshtein(unaccent(title), unaccent(?) ) < 4", follower.name).each do |video|
        video.follower = follower
        video.save
      end
    end

# /* Performance Number */
# regExp = /\([\d]{1}([\/]+[\d]{1})\)/
# split_value = "/(-)(/)/"
# Video.all.each do |video|
#   parsed_title = video.title.match(/\([\d]{1}([\/]+[\d]{1})\)/)
#   performance_number = parsed_title.split("/")
#   video.performance_number = performance_number.first
#   video.performance_total  = performance_number.last
# video.save
# end

##song match console
youtube_video = Video.find(22)
youtube_audio_full = YoutubeDL.download(
                        "https://www.youtube.com/watch?v=#{youtube_video.youtube_id}",
                        {format: '140', output:'~/environment/data/audio/%(id)s.wav'}
                      )

song = FFMPEG::Movie.new("#{youtube_audio_full.filename}")

if song.duration > 135

output_file_path = youtube_audio_full.filename.gsub(/.wav/, '_15s.wav')

song_transcoded = song.transcode( output_file_path,
                {custom: %w(-ss 00:02:00.00 -t 00:00:15.00 )} )

song_match_output = Video.song_match(output_file_path)

video = JSON.parse(song_match_output).extend Hashie::Extensions::DeepFind

if video.deep_find("spotify").present?

spotify_album_id = video.deep_find("spotify")["album"]["id"]
spotify_album_name = RSpotify::Album.find(spotify_album_id).name
spotify_artist_id = video.deep_find("spotify")["artists"][0]["id"]
spotify_artist_name = RSpotify::Artist.find(spotify_artist_id).name
spotify_artist_id_2 = video.deep_find("spotify")["artists"][1]["id"] if video.deep_find("spotify")["artists"][1].present?
spotify_artist_name_2 = RSpotify::Artist.find(spotify_artist_id_2).name if video.deep_find("spotify")["artists"][1].present?
spotify_track_id = video.deep_find("spotify")["track"]["id"]
spotify_track_name = RSpotify::Track.find(spotify_track_id).name
youtube_song_id = video.deep_find("youtube")["vid"] if video.deep_find("youtube").present?

youtube_video.update(
                        spotify_album_id: spotify_album_id,
                        spotify_album_name: spotify_album_name,
                        spotify_artist_id: spotify_artist_id,
                        spotify_artist_name: spotify_artist_name,
                        spotify_artist_id_2: spotify_artist_id_2,
                        spotify_artist_name_2: spotify_artist_name_2,
                        spotify_track_id: spotify_track_id,
                        spotify_track_name: spotify_track_name,
                        youtube_song_id: youtube_song_id
                      )

end
end

# confidence_score= video["metadata"]["music"]["score"],
# acrid= video["metadata"]["music"]["acrid"],


def houndify(file_name)
  requrl = "https://api.houndify.com/v1/audio"
  client_id = ENV["HOUNDIFY_CLIENT_ID"]
  client_key = ENV["HOUNDIFY_CLIENT_KEY"]

  http_method = "POST"
  http_uri = "/v1/identify"
  data_type = "audio"
  signature_version = "1"
  timestamp = Time.now.utc().to_i.to_s

  string_to_sign = http_method+"\n"+http_uri+"\n"+client_id+"\n"+data_type+"\n"+signature_version+"\n"+timestamp

  digest = OpenSSL::Digest.new('sha1')
  signature = Base64.encode64(OpenSSL::HMAC.digest(digest, client_key, string_to_sign))

  # file_name = ARGV[0]
  sample_bytes = File.size(file_name)

  url = URI.parse(requrl)
  File.open(file_name) do |file|
    req = Net::HTTP::Post::Multipart.new url.path,
      "sample" => UploadIO.new(file, "audio/mp3", file_name),
      'Hound-Request-Authentication' => client_id,
      'Hound-Client-Authentication' => signature,
      'Hound-Request-Info' => ,
      'UserID' => 'justin',
      'RequestID' => '1',
      # "client_id" => access_key,
      # "data_type"=> data_type,
      # "signature_version"=> signature_version,
      # "signature"=> signature,
      # "sample_bytes"=> sample_bytes,
       "TimeStamp" => timestamp
    res = Net::HTTP.start(url.host, url.port) do |http|
      http.request(req)
    end
    body = res.body.force_encoding("utf-8")
    body
  end
end
