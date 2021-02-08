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
#  tags                  :string
#  song_id               :bigint
#  youtube_song          :string
#  youtube_artist        :string
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
#  channel_id            :bigint
#  scanned_song          :boolean          default(FALSE)
#  hidden                :boolean          default(FALSE)
#  hd                    :boolean          default(FALSE)
#  popularity            :integer          default(0)
#  like_count            :integer          default(0)
#  dislike_count         :integer          default(0)
#  favorite_count        :integer          default(0)
#  comment_count         :integer          default(0)
#  event_id              :bigint
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
  belongs_to :channel, required: true
  belongs_to :event, required: false
  belongs_to :search_suggestion, required: false

  scope :filter_by_orchestra, ->(song_artist)     { joins(:song).where('songs.artist ILIKE ?', song_artist) }
  scope :filter_by_genre,     ->(song_genre)      { joins(:song).where('songs.genre ILIKE ?', song_genre) }
  scope :filter_by_leader,    ->(leader_name)     { joins(:leader).where('leaders.name ILIKE ?', leader_name) }
  scope :filter_by_follower,  ->(follower_name)   { joins(:follower).where('followers.name ILIKE ?', follower_name) }
  scope :filter_by_channel,   ->(channel_title)   { joins(:channel).where('channels.title ILIKE ?', channel_title) }
  scope :filter_by_event_id,  ->(event_id)        { where(event_id: event_id) }
  scope :filter_by_song_id,   ->(song_id)         { where(song_id: song_id) }
  scope :filter_by_hd,        ->(boolean)         { where(hd: boolean) }
  scope :filter_by_hidden,    ->                  { where(hidden: true) }
  scope :paginate,            ->(page, per_page)  { offset(per_page * page).limit(per_page) }

  # Active Admin scopes
  scope :has_song,          ->   { where.not(song_id: nil) }
  scope :has_leader,        ->   { where.not(leader_id: nil) }
  scope :has_follower,      ->   { where.not(follower_id: nil) }
  scope :missing_follower,  ->   { where(leader_id: nil) }
  scope :missing_leader,    ->   { where(follower_id: nil) }
  scope :has_youtube_match, ->   { where.not(youtube_artist: nil) }
  scope :has_acr_match,     ->   { where(acr_response_code: 0) }
  scope :scanned_acr,       ->   { where.not(acr_response_code: nil) }
  scope :not_scanned_acr,   ->   { where(acr_response_code: nil) }

  class << self
    def filter_by_query(query)
      where(id: VideosSearch.search(query).select(:video_id))
    end

    def update_hd_columns
      Video.where(hd: nil).each do |video|
        youtube_id = video.youtube_id
        UpdateHdColumnWorker.perform_async(youtube_id)
      end
    end

    def update_video_hd(youtube_id)
      yt_video = Yt::Video.new id: youtube_id
      video = Video.find_by(youtube_id: youtube_id)
      video.update(hd: yt_video.hd?)
    end

    def split_first_last_names
      Leader.all.each do |leader|
        leader_name_split = leader.name.split(' ')
        if leader_name_split.size == 2
          leader.update(first_name: leader_name_split.first,
                        last_name: leader_name_split.second)
        end
      end

      Follower.all.each do |follower|
        follower_name_split = follower.name.split(' ')
        if follower_name_split.size == 2
          follower.update(first_name: follower_name_split.first,
                          last_name: follower_name_split.second)
        end
      end
    end

    def update_imported_video_counts
      Channel.all.each do |channel|
        channel.update(imported_videos_count: channel.videos.count)
      end
    end

    def update_import_status
      Channel.where('imported_videos_count < total_videos_count').each do |channel|
        channel.update(imported: false)
      end
    end

    def import_all_channels
      Channel.where(imported: false).order(:id).each do |channel|
        channel_id = channel.channel_id
        Video.import_channel(channel_id)
      end
    end

    def match_all_music
      Video.where(acr_response_code: [nil, 3003]).order(:id).each do |video|
        youtube_id = video.youtube_id
        AcrMusicMatchWorker.perform_async(youtube_id)
      end
    end

    def match_all_dancers
      Follower.all.order(:id).each do |follower|
        Video.match_dancer(follower)
      end
      Leader.all.order(:id).each do |leader|
        Video.match_dancer(leader)
      end
    end

    def match_dancer(dancer)
      keywords = {}

      if dancer.first_name.present? && dancer.last_name.present?
        keywords.merge!(name_1: "%#{dancer.first_name[0, 1]}.#{dancer.last_name}%")
        keywords.merge!(name_2: "%#{dancer.first_name[0, 1]}. #{dancer.last_name}%")
      else
        keywords.merge!(name: "%#{dancer.name}%")
      end
      keywords.merge!(nickname: "%#{dancer.nickname}%") if dancer.nickname.present?

      model_attributes = %w[title]
      keyword_names = keywords.map { |k, _| k }
      combined_hash = model_attributes.product(keyword_names)

      sql_query = combined_hash.map do |attribute, keyword|
        "unaccent(#{attribute}) ILIKE unaccent(:#{keyword})"
      end

      sql_query = sql_query.join(' OR ')

      videos = Video.where(sql_query, keywords)

      videos.update_all("#{dancer.class.name.downcase}_id": dancer.id) if videos.present?
    end

    def match_all_songs
      Song.filter_by_active.sort_by_popularity.where.not(popularity: [false, nil]).each do |song|
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
          video.update(song: song)
        end
      end
    end

    def match_song(_song)
      model_attributes = %w[spotify_track_name youtube_song title description tags]
      keyword_names = keywords.map { |k, _v| k }
      combined_hash = model_attributes.product(keyword_names)

      sql_query = combined_hash.map do |attribute, keyword|
        "unaccent(#{attribute}) ILIKE unaccent(:#{keyword})"
      end

      sql_query = sql_query.join(' OR ')

      videos = Video.where(sql_query, keywords)

      videos.update_all("#{dancer.class.name.downcase}_id": dancer.id) if videos.present?
    end

    def calc_song_popularity
      Song.column_defaults['popularity']
      Song.column_defaults['occur_count']

      occur_num = Video.pluck(:song_id).compact!.tally
      max_value = occur_num.values.max
      popularity = occur_num.transform_values { |v| (v.to_f / max_value * 100).round }

      occur_num.each do |key, value|
        song = Song.find(key)
        song.update(occur_count: value)
      end

      popularity.each do |key, value|
        song = Song.find(key)
        song.update(popularity: value)
      end
    end

    def get_channel_video_ids(channel_id)
      `youtube-dl https://www.youtube.com/channel/#{channel_id}/videos  --get-id --skip-download`.split
    end

    def import_channel(channel_id)
      yt_channel = Yt::Channel.new id: channel_id
      yt_channel_video_count = yt_channel.video_count

      yt_channel_videos = yt_channel_video_count >= 500 ? Video.get_channel_video_ids(channel_id) : yt_channel.videos.map(&:id)

      channel = Channel.find_by(channel_id: yt_channel.id)
      channel_videos = channel.videos.map(&:youtube_id)
      yt_channel_videos_diff = yt_channel_videos - channel_videos

      yt_channel_videos_diff.each do |youtube_id|
        ImportVideoWorker.perform_async(youtube_id)
      end

      channel.update(
        title: yt_channel.title,
        thumbnail_url: yt_channel.thumbnail_url,
        total_videos_count: yt_channel.video_count
      )
    end

    def import_all_playlists
      Playlist.where(imported: false).each do |playlist|
        Video.import_playlist(playlist.slug)
      end
    end

    def import_playlist(playlist_id)
      yt_playlist = Yt::Playlist.new id: playlist_id
      yt_playlist_items = yt_playlist.playlist_items
      playlist = Playlist.find_by(slug: playlist_id)
                         .update(title: yt_playlist.title,
                                 description: yt_playlist.description,
                                 channel_title: yt_playlist.channel_title,
                                 channel_id: yt_playlist.channel_id,
                                 video_count: yt_playlist_items.size,
                                 imported: true)

      yt_playlist_items.map(&:video_id).each do |yt_video_id|
        video = Video.find_by(youtube_id: yt_video_id)
        video.update(popularity: video.popularity + 1) if video.present?
        ImportVideoWorker.perform_async(yt_video_id) if video.blank?
      end
    end

    def import_video(youtube_id)
      yt_video = Yt::Video.new id: youtube_id

      # if Channel.find_by(channel_id: yt_video.channel_id).blank?
      #   yt_channel = Yt::Channel.new id: yt_video.channel_id
      #   Channel.create(channel_id: yt_channel.id,
      #                  thumbnail_url: yt_channel.thumbnail_url,
      #                  title: yt_channel.title)
      # end

      video = Video.create(youtube_id: yt_video.id,
                           title: yt_video.title,
                           description: yt_video.description,
                           upload_date: yt_video.published_at,
                           duration: yt_video.duration,
                           view_count: yt_video.view_count,
                           tags: yt_video.tags,
                           hd: yt_video.hd?,
                           favorite_count: yt_video.favorite_count,
                           comment_count: yt_video.comment_count,
                           like_count: yt_video.like_count,
                           dislike_count: yt_video.dislike_count,
                           channel: Channel.find_by(channel_id: yt_video.channel_id))
      channel = Channel.find(video.channel.id)
      imported_videos_count = Video.where(channel: channel).count
      imported = imported_videos_count >= channel.total_videos_count
      channel.update(imported_videos_count: imported_videos_count)
    end

    def update_all_videos
      Video.where('dislike_count = 0 AND like_count = 0 AND favorite_count = 0').each do |video|
        UpdateVideoWorker.perform_async(video.youtube_id)
      end
    end

    def update_video(youtube_id)
      yt_video = Yt::Video.new id: youtube_id
      video = Video.find_by(youtube_id: youtube_id)
      video.update(favorite_count: yt_video.favorite_count,
                   comment_count: yt_video.comment_count,
                   like_count: yt_video.like_count,
                   dislike_count: yt_video.dislike_count)
    end

    def fetch_youtube_song(youtube_id)
      video = Video.find_by(youtube_id: youtube_id)
      yt_video = JSON.parse(YoutubeDL.download("https://www.youtube.com/watch?v=#{youtube_id}", skip_download: true)
                                  .to_json).extend Hashie::Extensions::DeepFind

      video.update(youtube_song: yt_video.deep_find('track'),
                   youtube_artist: yt_video.deep_find('artist'))
    end

    def acr_music_match(youtube_id)
      video = Video.find_by(youtube_id: youtube_id)
      clipped_audio = Video.clip_audio(youtube_id)
      acr_response_body = Video.acr_sound_match(clipped_audio)
      Video.parse_acr_response(acr_response_body, youtube_id)
      File.delete('diagram.txt') if File.exist?
    end

    # Generates audio clip from youtube_id and outputs file path
    def clip_audio(youtube_id)
      video = Video.find_by(youtube_id: youtube_id)
      audio_full = YoutubeDL.download(
        "https://www.youtube.com/watch?v=#{video.youtube_id}",
        { format: '140', output: '~/environment/data/audio/%(id)s.mp3' }
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
