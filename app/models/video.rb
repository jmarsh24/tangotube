# frozen_string_literal: true

# == Schema Information
#
# Table name: videos
#
#  id                 :bigint           not null, primary key
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  youtube_id         :string
#  song_id            :bigint
#  channel_id         :bigint
#  hidden             :boolean          default(FALSE)
#  popularity         :integer          default(0)
#  event_id           :bigint
#  click_count        :integer          default(0)
#  featured           :boolean          default(FALSE)
#  index              :text
#  metadata           :jsonb
#  imported_at        :datetime
#  upload_date        :date
#  upload_date_year   :integer          default(0)
#  title              :string           not null
#  description        :text             not null
#  hd                 :boolean          default(FALSE), not null
#  youtube_view_count :integer          default(0), not null
#  youtube_like_count :integer          default(0), not null
#  youtube_tags       :string           default([]), is an Array
#  duration           :integer          default(0), not null
#
class Video < ApplicationRecord
  acts_as_votable
  include Filterable
  include Indexable
  include Presentable

  attribute :metadata, ExternalVideoImport::Metadata.to_type

  validates :youtube_id, presence: true, uniqueness: true

  belongs_to :song, optional: true
  belongs_to :channel, optional: false, counter_cache: true
  belongs_to :event, optional: true, counter_cache: true
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :clips, dependent: :destroy
  has_many :dancer_videos, dependent: :destroy
  has_many :dancers, through: :dancer_videos
  has_many :leader_roles, -> { where(role: :leader) }, class_name: "DancerVideo", inverse_of: :video, dependent: :destroy
  has_many :leaders, through: :leader_roles, source: :dancer
  has_many :follower_roles, -> { where(role: :follower) }, class_name: "DancerVideo", inverse_of: :video, dependent: :destroy
  has_many :followers, through: :follower_roles, source: :dancer

  has_many :couple_videos, dependent: :destroy
  has_many :couples, through: :couple_videos
  has_one :orchestra, through: :song
  has_one :performance_video, dependent: :destroy
  has_one :performance, through: :performance_video

  has_one_attached :thumbnail

  scope :hidden, -> { where(hidden: true) }
  scope :not_hidden, -> { where(hidden: false) }
  scope :featured, -> { where(featured: true) }
  scope :has_song, -> { where.not(song_id: nil) }
  scope :has_leader, -> { where(id: DancerVideo.where(role: :leader, dancer:).select(:video_id)) }
  scope :has_follower, -> { where(id: DancerVideo.where(role: :follower, dancer:).select(:video_id)) }
  scope :has_leader_and_follower, -> { joins(:dancer_videos).where(dancer_videos: {role: [:leader, :follower]}) }
  scope :missing_follower, -> { joins(:dancer_videos).where.not(dancer_videos: {role: :follower}) }
  scope :missing_leader, -> { joins(:dancer_videos).where.not(dancer_videos: {role: :leader}) }
  scope :missing_song, -> { where(song_id: nil) }

  class << self
    def index_query
      <<~SQL.squish
        UPDATE videos
        SET index = query.index
        FROM (
          SELECT
            videos.id,
            LOWER(
              CONCAT_WS(' ',
                MIN(dancers.first_name), MIN(dancers.last_name),
                MIN(channels.channel_id), MIN(channels.title),
                STRING_AGG(songs.title, ' '), STRING_AGG(songs.genre, ' '), STRING_AGG(songs.artist, ' '),
                STRING_AGG(events.city, ' '), STRING_AGG(events.title, ' '), STRING_AGG(events.country, ' ')
              )
            ) as index
          FROM videos
          LEFT JOIN channels ON channels.id = videos.channel_id
          LEFT JOIN songs ON songs.id = videos.song_id
          LEFT JOIN events ON events.id = videos.event_id
          LEFT JOIN dancer_videos ON dancer_videos.video_id = videos.id
          LEFT JOIN dancers ON dancers.id = dancer_videos.dancer_id
          GROUP BY videos.id
        ) AS query
        WHERE videos.id IN (?) and query.id = videos.id
      SQL
    end

    def search_includes
      [
        :dancer_videos,
        :song,
        :event,
        :channel,
        :dancers,
        :performance_video,
        :performance,
        thumbnail_attachment: :blob
      ]
    end
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

  def thumbnail_url
    thumbnail.presence || "https://i.ytimg.com/vi/#{youtube_id}/hqdefault.jpg"
  end

  def to_param
    youtube_id
  end
end
