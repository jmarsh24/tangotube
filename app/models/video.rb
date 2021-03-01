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
#  scanned_youtube_music :boolean          default(FALSE)
#  click_count           :integer          default(0)
#

class Video < ApplicationRecord
  include Filterable

  validates :youtube_id, presence: true, uniqueness: true

  belongs_to :leader, optional: true
  belongs_to :follower, optional: true
  belongs_to :song, optional: true
  belongs_to :channel, optional: false
  belongs_to :event, optional: true

  scope :filter_by_orchestra, ->(song_artist)     { joins(:song).where("songs.artist ILIKE ?", song_artist) }
  scope :filter_by_genre,     ->(song_genre)      { joins(:song).where("songs.genre ILIKE ?", song_genre) }
  scope :filter_by_leader,    ->(leader_name)     { joins(:leader).where("leaders.name ILIKE ?", leader_name) }
  scope :filter_by_follower,  ->(follower_name)   { joins(:follower).where("followers.name ILIKE ?", follower_name) }
  scope :filter_by_channel,   ->(channel_title)   { joins(:channel).where("channels.title ILIKE ?", channel_title) }
  scope :filter_by_event_id,  ->(event_id)        { where(event_id: event_id) }
  scope :filter_by_song_id,   ->(song_id)         { where(song_id: song_id) }
  scope :filter_by_hd,        ->(boolean)         { where(hd: boolean) }
  scope :filter_by_hidden,    ->                  { where(hidden: true) }
  scope :paginate,            ->(page, per_page)  { offset(per_page * page).limit(per_page) }

  # Active Admin scopes
  scope :has_song,          ->   { where.not(song_id: nil) }
  scope :has_leader,        ->   { where.not(leader_id: nil) }
  scope :has_follower,      ->   { where.not(follower_id: nil) }
  scope :has_youtube_match, ->   { where.not(youtube_artist: nil) }
  scope :missing_follower,  ->   { where(follower_id: nil) }
  scope :missing_leader,    ->   { where(leader_id: nil) }
  scope :missing_song,      ->   { where(song_id: nil) }

  # Youtube Music Scopes
  scope :scanned_youtube_music,   -> { where(scanned_youtube_music: true) }
  scope :unscanned_youtube_music, -> { where(scanned_youtube_music: false) }

  # AcrCloud Response scopes
  scope :successful_acrcloud,     -> { where(acr_response_code: 0) }
  scope :unsuccesful_acrcloud,    -> { where.not(acr_response_code: [0, 1001]) }
  scope :scanned_acrcloud,        -> { where(acr_response_code: [0, 1001]) }
  scope :unscanned_acrcloud,      -> { where.not(acr_response_code: [0, 1001]) }

  # Attribute Matching Scopes
  scope :with_song_title, lambda { |song_title|
                            where("unaccent(spotify_track_name) ILIKE unaccent(:song_title)
                                                  OR unaccent(youtube_song) ILIKE unaccent(:song_title)
                                                  OR unaccent(title) ILIKE unaccent(:song_title)
                                                  OR unaccent(description) ILIKE unaccent(:song_title)
                                                  OR unaccent(tags) ILIKE unaccent(:song_title)",
                                  song_title: "%#{song_title}%")
                          }
  scope :with_song_artist_keyword, lambda { |song_artist_keyword|
                                     where("spotify_artist_name ILIKE :song_artist_keyword
                                            OR unaccent(spotify_artist_name_2) ILIKE unaccent(:song_artist_keyword)
                                            OR unaccent(youtube_artist) ILIKE unaccent(:song_artist_keyword)
                                            OR unaccent(description) ILIKE unaccent(:song_artist_keyword)
                                            OR unaccent(title) ILIKE unaccent(:song_artist_keyword)
                                            OR unaccent(tags) ILIKE unaccent(:song_artist_keyword)
                                            OR unaccent(spotify_album_name) ILIKE unaccent(:song_artist_keyword)",
                                           song_artist_keyword: "%#{song_artist_keyword}%")
                                   }

  scope :with_dancer_name_in_title, lambda { |dancer_name|
                                      where("unaccent(title) ILIKE unaccent(:dancer_name)", dancer_name: "%#{dancer_name}%")
                                    }

  # Combined Scopes

  scope :title_match_missing_leader, ->(leader_name) { missing_leader.with_dancer_name_in_title(leader_name) }
  scope :title_match_missing_follower, ->(follower_name) { missing_follower.with_dancer_name_in_title(follower_name) }

  class << self
    # Filters videos by the results from the materialized
    # full text search out of from VideosSearch
    def filter_by_query(query)
      where(id: VideosSearch.search(query).select(:video_id))
    end

    # All videos where the response code is not successfully identified,
    # send a request to acrcloud to search for a match
    def fetch_all_acr_cloud_matches
      where.not(acr_response_code: 0).find_each do |video|
        AcrMusicMatchWorker.perform_async(video.youtube_id)
      end
    end

    # For every video where we haven't checked
    # to see if youtube has a music match
    # Create a import youtube worker which will
    # check if youtube has identified the music contained in the video.
    def fetch_all_youtube_matches
      unscanned_youtube_music.find_each do |video|
        YoutubeMusicMatchWorker.perform_async(video.youtube_id)
      end
    end

    ## Update all videos with leader name match in video title with leader relation.
    def match_all_leaders
      Leader.all.find_each do |leader|
        videos = Video.title_match_missing_leader(leader.name) if leader.name.present?
        videos = videos.or(Video.title_match_missing_leader(leader.abrev_name)) if leader.abrev_name.present?
        videos = videos.or(Video.title_match_missing_leader(leader.abrev_name_nospace)) if leader.abrev_name_nospace.present?
        videos = videos.or(Video.title_match_missing_leader(leader.nickname)) if leader.nickname.present?

        next if videos.empty?

        videos.update_all(leader_id: leader.id)
      end
    end

    ## Update all videos with follower name match in video title with follower relation.
    def match_all_followers
      Follower.all.find_each do |follower|
        videos = Video.title_match_missing_follower(follower.name) if follower.name.present?
        videos = videos.or(Video.title_match_missing_follower(follower.abrev_name)) if follower.abrev_name.present?
        videos = videos.or(Video.title_match_missing_follower(follower.abrev_name_nospace)) if follower.abrev_name_nospace.present?
        videos = videos.or(Video.title_match_missing_follower(follower.nickname)) if follower.nickname.present?

        next if videos.empty?

        videos.update_all(follower_id: follower.id)
      end
    end

    # For every active song and in order of popularity search
    # for videos that have both the song title and last name
    # of the orchestra somewhere in the attributes
    def match_all_songs
      Song.filter_by_active.sort_by_popularity.find_each do |song|
        videos = Video.missing_song
                      .with_song_title(song.title)
                      .with_song_artist_keyword(song.last_name_search)
        next if videos.empty?

        videos.update_all(song_id: song.id)
      end
    end

    def match_all_music
      unscanned_acrcloud.each do |video|
        AcrMusicMatchWorker.perform_async(video.youtube_id)
      end
    end

    def import_all_playlists
      Playlist.where(imported: false).find_each do |playlist|
        Video.import_playlist(playlist.slug)
      end
    end
  end

  def clicked!
    self.click_count += 1
    self.popularity += 1
    save!
  end
end
