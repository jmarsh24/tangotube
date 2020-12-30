# == Schema Information
#
# Table name: videos
#
#  id                    :bigint           not null, primary key
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  title                 :text
#  youtube_id            :string
#  leader_id             :bigint
#  follower_id           :bigint
#  description           :string
#  duration              :integer
#  upload_date           :date
#  view_count            :integer
#  avg_rating            :integer
#  tags                  :string
#  song_id               :bigint
#  youtube_song          :string
#  youtube_artist        :string
#  performance_date      :datetime
#  performance_number    :integer
#  performance_total     :integer
#  videotype_id          :bigint
#  event_id              :bigint
#  confidence_score      :string
#  acrid                 :string
#  spotify_album_id      :string
#  spotify_album_name    :string
#  spotify_artist_id     :string
#  spotify_artist_id_2   :string
#  spotify_artist_name   :string
#  spotify_artist_name_2 :string
#  spotify_track_id      :string
#  spotify_track_name    :string
#  youtube_song_id       :string
#  isrc                  :string
#  acr_response_code     :integer
#  spotify_artist_name_3 :string
#  length                :interval
#  channel_id            :bigint
#

class Video < ApplicationRecord
  require 'openssl'
  require 'base64'
  require 'net/http/post/multipart'
  require 'irb'
  require 'json'

  include Filterable

  validates :youtube_id, presence: true, uniqueness: true

  belongs_to :leader, required: false
  belongs_to :follower, required: false
  belongs_to :song, required: false
  belongs_to :channel, required: false

  accepts_nested_attributes_for :song, allow_destroy: true

  scope :filter_by_genre,     ->(genre)    { where('songs.genre ILIKE ?', genre) }
  scope :filter_by_leader,    ->(leader)   { where('leaders.name ILIKE ?', leader) }
  scope :filter_by_follower,  ->(follower) { where('followers.name ILIKE ?', follower) }
  scope :filter_by_channel,   ->(channel)  { where('channels.title ILIKE ?', channel) }
  scope :filter_by_keyword,   ->(query)    { where('leaders.name ILIKE :query or
                                                    followers.name ILIKE :query or
                                                    songs.genre ILIKE :query or
                                                    songs.title ILIKE :query or
                                                    songs.artist ILIKE :query or
                                                    channels.title ILIKE :query or
                                                    spotify_artist_name ILIKE :query or
                                                    spotify_track_name ILIKE :query or
                                                    youtube_song ILIKE :query or
                                                    youtube_artist ILIKE :query or
                                                    title ILIKE :query or
                                                    description ILIKE :query', query: "%#{query}%") }
  scope :paginate,  ->(page, per_page) { offset(per_page * page).limit(per_page)}

  # Active Admin scopes
  scope :has_song,          ->   { where.not(song_id: nil) }
  scope :has_leader,        ->   { where.not(leader_id: nil) }
  scope :has_follower,      ->   { where.not(follower_id: nil) }
  scope :has_youtube_match, ->   { where.not(youtube_artist: nil) }
  scope :has_acr_match,     ->   { where(acr_response_code: 0) }

  class << self

    def update_imported_video_counts
      Channel.all.each do |channel|
        channel.update(imported_videos_count: channel.videos.count)
      end
    end

    def import_all_channels
      Channel.where(imported: false).order(:id).each do |channel|
        channel_id = channel.channel_id
        ImportChannelWorker.perform_async(channel_id)
      end
    end

    def match_all_music
      Video.where(acr_response_code: nil).order(:id).each do |video|
        youtube_id = video.youtube_id
        AcrMusicMatchWorker.perform_async(youtube_id)
      end
    end

    def match_all_dancers
      Leader.all.each do |leader|
        Video.all.where(leader_id: nil).where(  ' unaccent(title) ILIKE unaccent(:leader_name)
                                                  OR unaccent(description) ILIKE unaccent(:leader_name)
                                                  OR unaccent(title) ILIKE unaccent(:leader_nickname)
                                                  OR unaccent(description) ILIKE unaccent(:leader_nickname)',
                                                  leader_name: "%#{leader.name}%",
                                                  leader_nickname: "%#{leader.nickname.blank? ? "Do not perform match" : leader.nickname }%").each do |video|
          video.leader = leader
          video.save
        end
      end

      Follower.all.each do |follower|
        Video.all.where(follower_id: nil).where(  ' unaccent(title) ILIKE unaccent(:follower_name)
                                                    OR unaccent(description) ILIKE unaccent(:follower_name)
                                                    OR unaccent(title) ILIKE unaccent(:follower_nickname)
                                                    OR unaccent(description) ILIKE unaccent(:follower_nickname)',
                                                    follower_name: "%#{follower.name}%",
                                                    follower_nickname: "%#{follower.nickname.blank? ? "Do not perform match" : follower.nickname }%").each do |video|
          video.follower = follower
          video.save
        end
      end
    end

    def match_all_songs
      Song.all.each do |song|
        Video.where(song_id: nil)
             .where('unaccent(spotify_track_name) ILIKE unaccent(:song_title)
                      OR unaccent(youtube_song) ILIKE unaccent(:song_title)
                      OR unaccent(title) ILIKE unaccent(:song_title)
                      OR unaccent(description) ILIKE unaccent(:song_title)
                      OR unaccent(tags) ILIKE unaccent(:song_title)',
                      song_title: "%#{song.title}%")
             .where('spotify_artist_name ILIKE :song_artist_keyword
                      OR unaccent(spotify_artist_name_2) ILIKE unaccent(:song_artist_keyword)
                      OR unaccent(youtube_artist) ILIKE unaccent(:song_artist_keyword)
                      OR unaccent(description) ILIKE unaccent(:song_artist_keyword)
                      OR unaccent(title) ILIKE unaccent(:song_artist_keyword)
                      OR unaccent(tags) ILIKE unaccent(:song_artist_keyword)
                      OR unaccent(spotify_album_name) ILIKE unaccent(:song_artist_keyword)',
                      song_artist_keyword: "%#{song.last_name_search}%")
             .each do |video|
          video.song = song
          video.save
        end
      end
    end

    def get_channel_video_ids(channel_id)
      `youtube-dl https://www.youtube.com/channel/#{channel_id}  --get-id --skip-download`.split
    end

    def import_channel(channel_id)
      yt_channel = Yt::Channel.new id: channel_id
      yt_channel_video_count = yt_channel.video_count

      yt_channel_videos = yt_channel_video_count >= 500 ? Video.get_channel_video_ids(channel_id) : yt_channel.videos.map(&:id)

      channel = Channel.find_by(channel_id: channel_id)
      channel_videos = channel.videos.map(&:youtube_id)
      yt_channel_videos_diff = yt_channel_videos - channel_videos

      yt_channel_videos_diff.each do |youtube_id|
        ImportVideoWorker.perform_async(youtube_id)
      end

      imported = channel.imported_videos_count >= channel.total_videos_count ? true : false
      imported_videos_count = Video.where(channel_id: channel.id).count

      channel.update(
        thumbnail_url: yt_channel.thumbnail_url,
        total_videos_count: yt_channel.video_count,
        imported: imported,
        imported_videos_count: imported_videos_count
      )
    end

    def import_video(youtube_id)
      yt_video = Yt::Video.new id: youtube_id

      Channel.create( channel_id: yt_video.channel_id,
                           title: yt_video.channel_title ) if Channel.find_by(channel_id: yt_video.channel_id).nil?

      youtube_dl_output = JSON.parse(YoutubeDL.download("https://www.youtube.com/watch?v=#{youtube_id}",
                                      skip_download: true).to_json).extend Hashie::Extensions::DeepFind

      video = Video.create( youtube_id:     yt_video.id,
                            title:          yt_video.title,
                            description:    yt_video.description,
                            upload_date:    yt_video.published_at,
                            length:         yt_video.length,
                            duration:       yt_video.duration,
                            view_count:     yt_video.view_count,
                            tags:           yt_video.tags,
                            channel:        Channel.find_by(channel_id: yt_video.channel_id),
                            youtube_song:   youtube_dl_output.deep_find('track'),
                            youtube_artist: youtube_dl_output.deep_find('artist')
                          )
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
        { format: '140' , output: '~/environment/data/audio/%(id)s.mp3'}
      )

      song = FFMPEG::Movie.new(audio_full.filename.to_s)

      time_1 = audio_full.duration / 2
      time_2 = time_1 + 20

      output_file_path = audio_full.filename.gsub(/.mp3/, "_#{time_1}_#{time_2}.mp3")

      song_transcoded = song.transcode(output_file_path,
                                       { custom: %W[-ss #{time_1} -to #{time_2}] })
      output_file_path
    end

    # Parse response spotify, youtube, and isrc information from ACR_sound_match
    def parse_acr_response(acr_response, youtube_id)
      youtube_video = Video.find_by(youtube_id: youtube_id)
      video = JSON.parse(acr_response).extend Hashie::Extensions::DeepFind

      if video['status']['code'] == 0 && video.deep_find('spotify').present?

        spotify_album_id = video.deep_find('spotify')['album']['id'] if video.deep_find('spotify')['album'].present?
        if video.deep_find('spotify')['album']['id'].present?
          spotify_album_name = RSpotify::Album.find(spotify_album_id).name
        end

        if video.deep_find('spotify')['artists'][0].present?
          spotify_artist_id = video.deep_find('spotify')['artists'][0]['id']
        end

        if video.deep_find('spotify')['artists'][0].present?
          spotify_artist_name = RSpotify::Artist.find(spotify_artist_id).name
        end

        if video.deep_find('spotify')['artists'][1].present?
          spotify_artist_id_2 = video.deep_find('spotify')['artists'][1]['id']
        end

        if video.deep_find('spotify')['artists'][2].present?
          spotify_artist_id_3 = video.deep_find('spotify')['artists'][2]['id']
        end

        if video.deep_find('spotify')['artists'][1].present?
          spotify_artist_name_2 = RSpotify::Artist.find(spotify_artist_id_2).name
        end

        if video.deep_find('spotify')['track']['id'].present?
          spotify_track_id = video.deep_find('spotify')['track']['id']
        end

        if video.deep_find('spotify')['track']['id'].present?
          spotify_track_name = RSpotify::Track.find(spotify_track_id).name
        end

        youtube_song_id = video.deep_find('youtube')['vid'] if video.deep_find('youtube').present?
        isrc = video.deep_find('external_ids')['isrc'] if video.deep_find('external_ids')['isrc'].present?

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
          acr_response_code: video['status']['code']
        )

      elsif video['status']['code'] == 0 && video.deep_find('external_ids')['isrc'].present?
        youtube_video.update(
          acr_response_code: video['status']['code'],
          isrc: video.deep_find('external_ids')['isrc']
        )

      else
        youtube_video.update(
          acr_response_code: video['status']['code']
        )
      end
      rescue Module
      rescue RestClient::Exceptions::OpenTimeout
      rescue FFMPEG::Error
      rescue Errno::ENOENT
      rescue StandardError
    end

    # accepts file path and submits a http request to ACR Cloud API
    def acr_sound_match(file_path)
      requrl = 'http://identify-eu-west-1.acrcloud.com/v1/identify'
      access_key = ENV['ACRCLOUD_ACCESS_KEY']
      access_secret = ENV['ACRCLOUD_SECRET_KEY']

      http_method = 'POST'
      http_uri = '/v1/identify'
      data_type = 'audio'
      signature_version = '1'
      timestamp = Time.now.utc.to_i.to_s

      string_to_sign = http_method + "\n" + http_uri + "\n" + access_key + "\n" + data_type + "\n" + signature_version + "\n" + timestamp

      digest = OpenSSL::Digest.new('sha1')
      signature = Base64.encode64(OpenSSL::HMAC.digest(digest, access_secret, string_to_sign))

      sample_bytes = File.size(file_path)

      url = URI.parse(requrl)
      File.open(file_path) do |file|
        req = Net::HTTP::Post::Multipart.new url.path,
                                             'sample' => UploadIO.new(file, 'audio/mp3', file_path),
                                             'access_key' => access_key,
                                             'data_type' => data_type,
                                             'signature_version' => signature_version,
                                             'signature' => signature,
                                             'sample_bytes' => sample_bytes,
                                             'timestamp' => timestamp
        res = Net::HTTP.start(url.host, url.port) do |http|
          http.request(req)
        end
        body = res.body.force_encoding('utf-8')
        body
      end
    end

    # To fetch specific snippet from video, run this in the console:

    # Video.youtube_trim("5HfJ_n3wvLw","00:02:40.00", "00:02:55.00")
    def youtube_trim(youtube_id, time_1, time_2)
      youtube_video = YoutubeDL.download(
        "https://www.youtube.com/watch?v=#{youtube_id}",
        { format: 'bestvideo[ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best',
          output: '~/downloads/youtube/%(title)s-%(id)s.%(ext)s' }
      )
      video = FFMPEG::Movie.new(youtube_video.filename.to_s)
      timestamp = time_1.to_s.split(':')
      timestamp_2 = time_2.to_s.split(':')
      output_file_path = youtube_video.filename.gsub(/.mp4/,
                                                     "_trimmed_#{timestamp[1]}_#{timestamp[2]}_to_#{timestamp_2[1]}_#{timestamp_2[2]}.mp4")
      video_transcoded = video.transcode(output_file_path, custom: %W[-ss #{time_1} -to #{time_2}])
    end
  end
end
