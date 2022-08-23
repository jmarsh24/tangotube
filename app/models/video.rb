class Video < ApplicationRecord
  acts_as_votable
  include Filterable

  PERFORMANCE_REGEX=/(?<=\s|^|#)[1-8]\s?(of|de|\/|-)\s?[1-8](\s+$|)/

  validates :youtube_id, presence: true, uniqueness: true

  belongs_to :leader, optional: true, counter_cache: true
  belongs_to :follower, optional: true, counter_cache: true
  belongs_to :song, optional: true
  belongs_to :channel, optional: false, counter_cache: true
  belongs_to :event, optional: true, counter_cache: true
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :yt_comments, dependent: :destroy
  has_many :clips, dependent: :destroy
  has_many :dancer_videos, dependent: :destroy
  has_many :dancers, through: :dancer_videos
  has_many :couple_videos, dependent: :destroy
  has_many :couples, through: :couple_videos
  has_one :orchestra, through: :song
  has_one :performance_video, dependent: :destroy
  has_one :performance, through: :performance_video
  counter_culture :song
  counter_culture [:song, :orchestra]
  counter_culture :event

  scope :filter_by_orchestra, ->(song_artist, _user) { joins(:song).where("unaccent(songs.artist) ILIKE unaccent(?)", song_artist)}
  scope :filter_by_genre, ->(song_genre, _user) { joins(:song).where("unaccent(songs.genre) ILIKE unaccent(?)", song_genre) }
  scope :filter_by_leader, ->(leader, _user) { joins(:leader).where("unaccent(leaders.name) ILIKE unaccent(?)", leader) }
  scope :filter_by_follower, ->(follower, _user) { joins(:follower).where("unaccent(followers.name) ILIKE unaccent(?)", follower) }
  scope :filter_by_channel, ->(channel_id, _user) { joins(:channel).where("channels.channel_id ILIKE ?", channel_id) }
  scope :filter_by_event_id, ->(event_id, _user) { where(event_id:) }
  scope :filter_by_event, ->(event_slug, _user) { joins(:event).where("events.slug ILIKE ?", event_slug) }
  scope :filter_by_song_id, ->(song_id, _user) { where(song_id:) }
  scope :filter_by_song, ->(song_slug, _user) { joins(:song).where("songs.slug ILIKE ?", song_slug) }
  scope :filter_by_hd, ->(boolean, _user) { where(hd: boolean) }
  scope :filter_by_dancer, ->(_boolean, _user) { joins(:leader, :follower) }
  scope :filter_by_year,->(year, _user) { where("extract(year from performance_date) = ?", year) }
  scope :filter_by_upload_year,->(year, _user) { where("extract(year from upload_date) = ?", year) }
  scope :hidden, -> { where(hidden: true) }
  scope :not_hidden, -> { where(hidden: false) }
  scope :featured?,-> { where(featured: true) }

  # Active Admin scopes
  scope :has_song, -> { where.not(song_id: nil) }
  scope :has_leader, -> { where.not(leader_id: nil) }
  scope :has_follower, -> { where.not(follower_id: nil) }
  scope :missing_follower, -> { where(follower_id: nil) }
  scope :missing_leader, -> { where(leader_id: nil) }
  scope :missing_song, -> { where(song_id: nil) }

  # Youtube Music Scopes
  scope :scanned_youtube_music, -> { where(scanned_youtube_music: true) }
  scope :not_scanned_youtube_music, -> { where(scanned_youtube_music: false) }
  scope :has_youtube_song, -> { where.not(youtube_song: nil) }

  # AcrCloud Response scopes
  scope :successful_acrcloud, -> { where(acr_response_code: 0) }
  scope :not_successful_acrcloud, -> { where(acr_response_code: 1001) }
  scope :scanned_acrcloud, -> { where(acr_response_code: [0, 1001]) }
  scope :not_scanned_acrcloud,
        -> {
          where
            .not(acr_response_code: [0, 1001])
        }

  # Attribute Matching Scopes
  scope :with_song_title,
        lambda { |song_title|
          where(
            'unaccent(spotify_track_name) ILIKE unaccent(:song_title)
                                    OR unaccent(youtube_song) ILIKE unaccent(:song_title)
                                    OR unaccent(title) ILIKE unaccent(:song_title)
                                    OR unaccent(description) ILIKE unaccent(:song_title)
                                    OR unaccent(tags) ILIKE unaccent(:song_title)
                                    OR unaccent(acr_cloud_track_name) ILIKE unaccent(:song_title)',
            song_title: "%#{song_title}%"
          )
        }

  scope :with_song_artist_keyword,
        lambda { |song_artist_keyword|
          where(
            'spotify_artist_name ILIKE :song_artist_keyword
                                            OR unaccent(spotify_artist_name_2) ILIKE unaccent(:song_artist_keyword)
                                            OR unaccent(youtube_artist) ILIKE unaccent(:song_artist_keyword)
                                            OR unaccent(description) ILIKE unaccent(:song_artist_keyword)
                                            OR unaccent(title) ILIKE unaccent(:song_artist_keyword)
                                            OR unaccent(tags) ILIKE unaccent(:song_artist_keyword)
                                            OR unaccent(spotify_album_name) ILIKE unaccent(:song_artist_keyword)
                                            OR unaccent(acr_cloud_album_name) ILIKE unaccent(:song_artist_keyword)
                                            OR unaccent(acr_cloud_artist_name) ILIKE unaccent(:song_artist_keyword)
                                            OR unaccent(acr_cloud_artist_name_1) ILIKE unaccent(:song_artist_keyword)',
            song_artist_keyword: "%#{song_artist_keyword}%"
          )
        }

  # Combined Scopes

  scope :title_match_missing_leader,
        ->(leader_name) {
          missing_leader.with_dancer_name_in_title(leader_name)
        }
  scope :title_match_missing_follower,
        ->(follower_name) {
          missing_follower.with_dancer_name_in_title(follower_name)
        }

  class << self

    def search(query, _user)
      filter_by_query(query)
    end

    def filter_by_query(query, _user)
      where(id: VideoSearch.search(query).select(:video_id))
    end

    def refresh_materialized_view
      Scenic.database.refresh_materialized_view(
        :video_searches,
        concurrently: true,
      )
    end

    def search_includes
      %i[
        song
        leader
        follower
        event
        channel
        dancers
        performance_video
        performance
      ]
    end

    def with_dancer_name_in_title(_name)
      search( "*",
              filter: ["title = name"] )
    end

    def filter_by_watched(boolean, user)
      case boolean
      when "true"
        where(id: user.votes.where(vote_scope: "watchlist").pluck(:id))
      when "false"
        where.not(id: user.votes.where(vote_scope: "watchlist").pluck(:id))
      end
    end

    def filter_by_liked(boolean, user)
      case boolean
      when "true"
        where(id: user.find_up_voted_items.pluck(:id))
      when "false"
        where(id: user.find_up_downsvoted_items.pluck(:id))
      end
    end

    def most_viewed_videos_by_month
      where( id: Ahoy::Event.most_viewed_videos_by_month)
    end
  end

  def viewed_within_last_month?
    Video.where( id: Ahoy::Event.most_viewed_videos_by_month).any?
  end

  def grep_title_for_dancer
    Dancer.all.find { |dancer| title.parameterize.match(dancer.name.parameterize) }
    dancers << dancer if dancer.present?
  end

  def grep_performance_number
    array = []
    array << title if title.present?
    array << description if description.present?
    search_string = array.join(" ")
    return unless search_string.match?(PERFORMANCE_REGEX)
    performance_array = search_string.match(PERFORMANCE_REGEX)[0].tr("^0-9", " ").split(" ").map(&:to_i)
    return if performance_array.empty?
    return if performance_array.first > performance_array.second || performance_array.second == 1
    self.performance_number = performance_array.first
    self.performance_total_number = performance_array.second
  end

  def grep_title_description_acr_cloud_song
    array = []
    array << title if title.present?
    array << description if description.present?
    array << spotify_artist_name if spotify_artist_name.present?
    array << spotify_artist_name_2 if spotify_artist_name_2.present?
    array << spotify_track_name if spotify_track_name.present?
    array << spotify_album_name if spotify_album_name.present?
    array << acr_cloud_artist_name if acr_cloud_artist_name.present?
    array << acr_cloud_artist_name_1 if acr_cloud_artist_name_1.present?
    array << acr_cloud_track_name if acr_cloud_track_name.present?
    array << acr_cloud_album_name if acr_cloud_album_name.present?
    array << youtube_song if youtube_song.present?
    array << youtube_artist if youtube_artist.present?
    search_string = array.join(" ")

    self.song = Song.filter_by_active
                    .find_all { |song| search_string.parameterize.match(song.title.parameterize)}
                    .find { |song| search_string.parameterize.match(song.last_name_search.parameterize)}
  end

  def display
    @display ||= Video::Display.new(self)
  end

  def clicked!
    increment(:click_count)
    increment(:popularity)
    save!
  end

  def liked_by
    votes_for.where(vote_scope: "like")&.where(vote_flag: true)&.map(&:voter_id)
  end

  def disliked_by
    votes_for.where(vote_scope: "like")&.where(vote_flag: false)&.map(&:voter_id)
  end

  def watched_by
    votes_for.where(vote_scope: "watchlist")&.where(vote_flag: true)&.map(&:voter_id)
  end

  def not_watched_by
    User.all.pluck(:id) - votes_for.where(vote_scope: "watchlist")&.where(vote_flag: true)&.map(&:voter_id)
  end

  def bookmarked_by
    votes_for.where(vote_scope: "bookmark")&.map(&:voter_id)
  end

  def watched_later_by
    votes_for.where(vote_scope: "watchlist")&.where(vote_flag: false)&.map(&:voter_id)
  end

  def featured?
    featured
  end

  def dancer?
    leader.present? || follower.present?
  end

  def dancers_names
    dancer&.map(&:name)
  end

  def song_title
    song&.title
  end

  def song_artist
    song&.artist
  end
end
