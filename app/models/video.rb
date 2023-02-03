# frozen_string_literal: true

# == Schema Information
#
# Table name: videos
#
#  id                             :bigint           not null, primary key
#  created_at                     :datetime         not null
#  updated_at                     :datetime         not null
#  title                          :text
#  youtube_id                     :string
#  leader_id                      :bigint
#  follower_id                    :bigint
#  description                    :string
#  duration                       :integer
#  upload_date                    :datetime
#  view_count                     :integer
#  tags                           :string
#  song_id                        :bigint
#  youtube_song                   :string
#  youtube_artist                 :string
#  acrid                          :string
#  spotify_album_id               :string
#  spotify_album_name             :string
#  spotify_artist_id              :string
#  spotify_artist_id_2            :string
#  spotify_artist_name            :string
#  spotify_artist_name_2          :string
#  spotify_track_id               :string
#  spotify_track_name             :string
#  youtube_song_id                :string
#  isrc                           :string
#  acr_response_code              :integer
#  channel_id                     :bigint
#  scanned_song                   :boolean          default(FALSE)
#  hidden                         :boolean          default(FALSE)
#  hd                             :boolean          default(FALSE)
#  popularity                     :integer          default(0)
#  like_count                     :integer          default(0)
#  dislike_count                  :integer          default(0)
#  favorite_count                 :integer          default(0)
#  comment_count                  :integer          default(0)
#  event_id                       :bigint
#  scanned_youtube_music          :boolean          default(FALSE)
#  click_count                    :integer          default(0)
#  acr_cloud_artist_name          :string
#  acr_cloud_artist_name_1        :string
#  acr_cloud_album_name           :string
#  acr_cloud_track_name           :string
#  performance_date               :datetime
#  spotify_artist_id_1            :string
#  spotify_artist_name_1          :string
#  performance_number             :integer
#  performance_total_number       :integer
#  cached_scoped_like_votes_total :integer          default(0)
#  cached_scoped_like_votes_score :integer          default(0)
#  cached_scoped_like_votes_up    :integer          default(0)
#  cached_scoped_like_votes_down  :integer          default(0)
#  cached_weighted_like_score     :integer          default(0)
#  cached_weighted_like_total     :integer          default(0)
#  cached_weighted_like_average   :float            default(0.0)
#  featured                       :boolean          default(FALSE)
#
class Video < ApplicationRecord
  acts_as_votable
  include Filterable

  PERFORMANCE_REGEX = /(?<=\s|^|#)[1-8]\s?(of|de|\/|-)\s?[1-8](\s+$|)/

  validates :youtube_id, presence: true, uniqueness: true

  belongs_to :song, optional: true
  belongs_to :channel, optional: false, counter_cache: true
  belongs_to :event, optional: true, counter_cache: true
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :yt_comments, dependent: :destroy
  has_many :clips, dependent: :destroy
  has_many :dancer_videos, dependent: :destroy
  has_many :dancers, through: :dancer_videos
  has_many :follower_roles, ->(_role) { where(role: :follower) }, class_name: "DancerVideo"
  has_many :leader_roles, ->(_role) { where(role: :leader) }, class_name: "DancerVideo"
  has_many :leaders, through: :leader_roles, source: :dancer
  has_many :followers, through: :follower_roles, source: :dancer

  has_many :couple_videos, dependent: :destroy
  has_many :couples, through: :couple_videos
  has_one :orchestra, through: :song
  has_one :performance_video, dependent: :destroy
  has_one :performance, through: :performance_video
  counter_culture :song
  counter_culture [:song, :orchestra]
  counter_culture :event

  scope :filter_by_orchestra, ->(song_artist, _user) { joins(:song).where("unaccent(songs.artist) ILIKE unaccent(?)", song_artist) }
  scope :filter_by_genre, ->(song_genre, _user) { joins(:song).where("unaccent(songs.genre) ILIKE unaccent(?)", song_genre) }
  scope :with_leader, ->(dancer) {
    where(id: DancerVideo.where(role: :leader, dancer:).select(:video_id))
  }
  scope :with_follower, ->(dancer) {
    where(id: DancerVideo.where(role: :follower, dancer:).select(:video_id))
  }
  scope :filter_by_leader, ->(dancer_name, _user) {
    with_leader(Dancer.where("unaccent(dancers.name) ILIKE unaccent(?)", dancer_name))
  }
  scope :filter_by_follower, ->(dancer_name, _user) {
    with_follower(Dancer.where("unaccent(dancers.name) ILIKE unaccent(?)", dancer_name))
  }
  scope :filter_by_couples, ->(couple_name, _user) {
    where(id: CoupleVideo.joins(:couple).where(couple: {slug: couple_name}).select(:video_id))
  }
  scope :filter_by_channel, ->(channel_id, _user) { joins(:channel).where("channels.channel_id ILIKE ?", channel_id) }
  scope :filter_by_event_id, ->(event_id, _user) { where(event_id:) }
  scope :filter_by_event, ->(event_slug, _user) { joins(:event).where("events.slug ILIKE ?", event_slug) }
  scope :filter_by_song_id, ->(song_id, _user) { where(song_id:) }
  scope :filter_by_song, ->(song_slug, _user) { joins(:song).where("songs.slug ILIKE ?", song_slug) }
  scope :filter_by_hd, ->(boolean, _user) { where(hd: boolean) }
  scope :filter_by_year, ->(year, _user) { where("extract(year from performance_date) = ?", year) }
  scope :filter_by_upload_year, ->(year, _user) { where("extract(year from upload_date) = ?", year) }
  scope :hidden, -> { where(hidden: true) }
  scope :not_hidden, -> { where(hidden: false) }
  scope :featured?, -> { where(featured: true) }
  scope :has_song, -> { where.not(song_id: nil) }
  scope :has_leader, -> { where(id: DancerVideo.where(role: :leader, dancer:).select(:video_id)) }
  scope :has_follower, -> { where(id: DancerVideo.where(role: :follower, dancer:).select(:video_id)) }
  scope :has_leader_and_follower, -> { joins(:dancer_videos).where(dancer_videos: {role: [:leader, :follower]}) }
  scope :missing_follower, -> { joins(:dancer_videos).where.not(dancer_videos: {role: :follower}) }
  scope :missing_leader, -> { joins(:dancer_videos).where.not(dancer_videos: {role: :leader}) }
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

  scope :with_same_performance, ->(video) {
                                  includes(Video.search_includes)
                                    .where(channel_id: video.channel_id)
                                    .has_leader_and_follower
                                    .where(hidden: false)
                                    .where.not(youtube_id: video.youtube_id)
                                }

  scope :with_same_dancers, ->(video) {
    includes(Video.search_includes)
      .where("upload_date <= ?", video.upload_date + 7.days)
      .where("upload_date >= ?", video.upload_date - 7.days)
      .has_leader_and_follower
      .with_leader(video.leaders.first)
      .with_follower(video.followers.first)
      .where(hidden: false)
      .where.not(youtube_id: video.youtube_id)
  }

  scope :with_same_event, ->(video) {
    includes(Video.search_includes)
      .where(event_id: video.event_id)
      .where.not(event: nil)
      .where("upload_date <= ?", video.upload_date + 7.days)
      .where("upload_date >= ?", video.upload_date - 7.days)
      .where(hidden: false)
      .where.not(youtube_id: video.youtube_id)
  }

  scope :with_same_song, ->(video) {
    includes(Video.search_includes)
      .where(song_id: video.song_id)
      .has_leader_and_follower
      .where(hidden: false)
      .where.not(song_id: nil)
      .where.not(youtube_id: video.youtube_id)
  }

  scope :with_same_channel, ->(video) {
    includes(Video.search_includes)
      .where(channel_id: video.channel_id)
      .has_leader_and_follower
      .where(hidden: false)
      .where.not(youtube_id: video.youtube_id)
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

    def index_query
      <<~SQL
        UPDATE orders
        SET index = query.index
        FROM (
          SELECT
            orders.id,
            LOWER(
              CONCAT_WS(' ',
                orders.reference, ARRAY_TO_STRING(orders.tags, ' '),
                MIN(users.email), MIN(users.first_name), MIN(users.last_name),
                MIN(companies.slug), MIN(companies.name),
                STRING_AGG(invoices.reference, ' '), STRING_AGG(invoices.booking_number::text, ' '), STRING_AGG(invoices.address ->> 'city', ' '), STRING_AGG(invoices.address ->> 'first_name', ' '), STRING_AGG(invoices.address ->> 'last_name', ' '),
                STRING_AGG(deliveries.reference, ' '), STRING_AGG(deliveries.tracking_code, ' '), STRING_AGG(deliveries.address ->> 'city', ' '), STRING_AGG(deliveries.address ->> 'first_name', ' '), STRING_AGG(deliveries.address ->> 'last_name', ' '),
                STRING_AGG(picklists.reference, ' '),
                STRING_AGG(products.sku, ' '), STRING_AGG(products.slug, ' '), STRING_AGG(products.name::text, ' '), STRING_AGG(products.artist::text, ' '),
                STRING_AGG(product_variants.sku, ' '),
                STRING_AGG(items.validation_code, ' ')
              )
            ) as index
          FROM orders
          LEFT JOIN users ON users.id = orders.user_id
          LEFT JOIN companies ON companies.id = orders.company_id
          LEFT JOIN invoices ON invoices.order_id = orders.id
          LEFT JOIN deliveries ON deliveries.order_id = orders.id
          LEFT JOIN picklists ON picklists.id = deliveries.picklist_id
          LEFT JOIN items ON items.invoice_id = invoices.id OR items.delivery_id = deliveries.id OR items.incoming_delivery_id = deliveries.id
          LEFT JOIN products ON items.product_id = products.id
          LEFT JOIN product_variants ON items.product_variant_id = product_variants.id
          GROUP BY orders.id
        ) AS query
        WHERE orders.id IN (?) and query.id = orders.id
      SQL
    end
  end

    def search(query, _user)
      filter_by_query(query)
    end

    def filter_by_query(query, _user)
    end

    def search_includes
      %i[
        dancer_videos
        song
        event
        channel
        dancers
        performance_video
        performance
      ]
    end

    def with_dancer_name_in_title(name)
      where("unaccent(title) ILIKE unaccent(?)", "%#{name}%")
    end

    def filter_by_dancer(name, _user)
      if name == "true"
        joins(:dancers)
      else
        joins(:dancers).where("dancers.slug ILIKE ?", name)
      end
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
  end

  def grep_title_for_dancer
    dancer_matches = Dancer.all.select { |dancer| title.parameterize.match(dancer.name.parameterize) }
    dancer_matches.each do |dancer|
      dancers << dancer unless dancers.include?(dancer)
    end
  end

  def grep_performance_number
    array = []
    array << title if title.present?
    array << description if description.present?
    search_string = array.join(" ")
    return unless search_string.match?(PERFORMANCE_REGEX)
    performance_array = search_string.match(PERFORMANCE_REGEX)[0].tr("^0-9", " ").split.map(&:to_i)
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
      .select { |song| search_string.parameterize.match(song.title.parameterize) }
      .find { |song| search_string.parameterize.match(song.last_name_search.parameterize) }
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

  def thumbnail_url
    "https://i.ytimg.com/vi/#{youtube_id}/hq720.jpg"
  end
end
