# == Schema Information
#
# Table name: videos
#
#  id                 :bigint           not null, primary key
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  title              :text
#  youtube_id         :string
#  leader_id          :bigint
#  follower_id        :bigint
#  description        :string
#  channel            :string
#  channel_id         :string
#  duration           :integer
#  upload_date        :date
#  view_count         :integer
#  avg_rating         :integer
#  tags               :string
#  song_id            :bigint
#  youtube_song       :string
#  youtube_artist     :string
#  performance_date   :datetime
#  performance_number :integer
#  performance_total  :integer
#  videotype_id       :bigint
#  event_id           :bigint
#

class Video < ApplicationRecord
  include Houndify

  require "openssl"
  require "base64"
  require "net/http/post/multipart"
  require "irb"
  require "json"
  require "securerandom"
  require "houndify"


  # validates :leader, presence: true
  # validates :follower, presence: true
  # validates :song, presence: true
  # validates :artist, presence: true
  # validates :youtube_id, presence: true, uniqueness: true
  # validates :title, presence: true

  belongs_to :leader, required: false
  belongs_to :follower, required: false
  belongs_to :song, required: false
  belongs_to :videotype, required: false
  belongs_to :event, required: false

  scope :genre, ->(genre) { joins(:song).where(songs: {genre: genre}) }
  scope :videotype, ->(videotype) { joins(:videotype).where(videotypes: {name: videotype}) }
  scope :leader, ->(leader) { joins(:leader).where(leaders: {name: leader}) }
  scope :follower, ->(follower) { joins(:follower).where(followers: {name: follower}) }
  scope :event, ->(event) { joins(:event).where(events: {name: event}) }
  scope :channel, ->(channel) { where(channel: channel) }

  scope :paginate, lambda { |page, per_page|
    offset(per_page * page).limit(per_page)
  }

  class << self
    def search(query)
      if query
        where('leaders.name ILIKE :query or
                followers.name ILIKE :query or
                songs.genre ILIKE :query or
                songs.title ILIKE :query or
                songs.artist ILIKE :query or
                videotypes.name ILIKE :query',
          query: "%#{query.downcase}%")
      else
        all
      end
    end

    # To fetch video, run this from the console:
    # Video.parse_json('data/030tango_channel_data_json')
    # Video.parse_json('/Users/justin/desktop/environment/data/channel_json')
    def parse_json(file_path)
      json_file = Dir.glob("#{file_path}/**/*.json").map
      json_file.each do |youtube_video|
        video = JSON.parse(File.read(youtube_video))
        video = Video.new(
          youtube_id: video["id"],
          title: video["title"],
          description: video["description"],
          youtube_song: video["track"],
          youtube_artist: video["artist"],
          upload_date: video["upload_date"],
          channel: video["uploader"],
          duration: video["duration"],
          channel_id: video["uploader_id"],
          view_count: video["view_count"],
          avg_rating: video["average_rating"],
          tags: video["tags"]
        )
        # video.grep_title
        video.save
      end
    end

    # To fetch video, run this from the console:
    # Video.for_channel('UCtdgMR0bmogczrZNpPaO66Q')
    def for_channel(id)
      channel = Yt::Channel.new id: id
      channel.videos.each do |youtube_video|
        video = Video.new(youtube_id: youtube_video.id, title: youtube_video.title)
        video.grep_title
        video.save
      end
    end

    # Submits ACRCloud HTTP request
    def song_match(file_name)
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

    def ask_hound(user_id, query)
      @regex_hastag = /#\w+/
      query = query.gsub(@regex_hastag, '')
      info query
      client = Houndify::Client.new(user_id)
      response = client.request(query)
      info response
      publish 'hound-bot', response
      response['AllResults'][0]['SpokenResponseLong']
    end

    def houndify_sound_match(user_id, file_path)
      Houndify.set_secrets(ENV['HOUNDIFY_CLIENT_ID'],
                           ENV['HOUNDIFY_CLIENT_KEY'])
      client = Houndify::Client.new(user_id)
      response = client.sound_match(file_path)
      response
      ap JSON.parse(response.body)
    end

    def song_match_all(count, offset)
      Video.limit(count).offset(offset).each do |youtube_video|
        youtube_audio_full = YoutubeDL.download(
          "https://www.youtube.com/watch?v=#{youtube_video.youtube_id}",
          {format: "140", output: "~/environment/data/audio/%(id)s.wav"}
        )

        song = FFMPEG::Movie.new(youtube_audio_full.filename.to_s)

        output_file_path = youtube_audio_full.filename.gsub(/.wav/, "_15s.wav")

        song_transcoded = song.transcode(output_file_path,
          {audio_codec: "pcm_s16le", audio_channels: 1, audio_bitrate: 16, audio_sample_rate: 16000, custom: %w[-ss 00:01:30.00 -t 00:00:15.00]})

        song_match_output = Video.houndify(output_file_path)

        video = JSON.parse(song_match_output).extend Hashie::Extensions::DeepFind

        spotify_album_id = video.deep_find("spotify")["album"]["id"]
        spotify_album_name = RSpotify::Album.find(spotify_album_id).name
        spotify_artist_id = video.deep_find("spotify")["artists"][0]["id"]
        spotify_artist_name = RSpotify::Artist.find(spotify_artist_id).name
        if video.deep_find("spotify")["artists"][1].present?
          spotify_artist_id_2 = video.deep_find("spotify")["artists"][1]["id"]
        end
        if video.deep_find("spotify")["artists"][1].present?
          spotify_artist_name_2 = RSpotify::Artist.find(spotify_artist_id_2).name
        end
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
    end
end
