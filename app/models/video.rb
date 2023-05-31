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
  scope :missing_song, -> { where(song_id: nil) }

  scope :has_leader, -> { where("EXISTS (SELECT 1 FROM dancer_videos WHERE dancer_videos.video_id = videos.id AND role = 'leader')") }
  scope :has_follower, -> { where("EXISTS (SELECT 1 FROM dancer_videos WHERE dancer_videos.video_id = videos.id AND role = 'follower')") }
  scope :has_leader_and_follower, -> { has_leader.has_follower }

  scope :query, ->(value) { search(value) }
  scope :hd, ->(value) { where(hd: value) }
  scope :dancer, ->(value) { value ? joins(:dancer_videos, :dancers) : where.not(id: DancerVideo.select(:video_id)) }
  scope :liked_by_user, ->(user) { where(id: user.find_up_voted_items.pluck(:id)) }
  scope :watched_by_user, ->(user) { where(id: user.votes.where(vote_scope: "watchlist", vote_flag: true).pluck(:votable_id)) }
  scope :leader, ->(value) {
                   joins("JOIN dancer_videos AS leader_dancer_videos ON leader_dancer_videos.video_id = videos.id")
                     .joins("JOIN dancers AS leader_dancers ON leader_dancers.id = leader_dancer_videos.dancer_id")
                     .where(leader_dancers: {slug: value}, leader_dancer_videos: {role: "leader"})
                 }
  scope :follower, ->(value) {
                     joins("JOIN dancer_videos AS follower_dancer_videos ON follower_dancer_videos.video_id = videos.id")
                       .joins("JOIN dancers AS follower_dancers ON follower_dancers.id = follower_dancer_videos.dancer_id")
                       .where(follower_dancers: {slug: value}, follower_dancer_videos: {role: "follower"})
                   }
  scope :orchestra, ->(value) { joins(:song, :orchestra).where(orchestras: {slug: value}) }
  scope :genre, ->(value) { joins(:song).where("LOWER(songs.genre) = ?", value.downcase) }
  scope :year, ->(value) { where(upload_date_year: value) }
  scope :song, ->(value) { joins(:song).where(songs: {slug: value}) }
  scope :event, ->(value) { joins(:event).where(events: {slug: value}) }
  scope :hidden, ->(value) { where(hidden: value) }
  scope :channel, ->(value) { joins(:channel).where(channels: {channel_id: value}) }
  scope :exclude_youtube_id, ->(value) { where.not(youtube_id: value) }

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
                MIN(normalize(dancers.first_name)),
                MIN(normalize(dancers.last_name)),
                MIN(normalize(channels.channel_id)),
                MIN(normalize(channels.title)),
                MIN(normalize(songs.title)),
                MIN(normalize(songs.genre)),
                MIN(normalize(songs.artist)),
                MIN(normalize(orchestras.name)),
                MIN(normalize(events.city)),
                MIN(normalize(events.title)),
                MIN(normalize(events.country)),
                normalize(videos.youtube_id),
                normalize(videos.title),
                normalize(videos.description)
              )
            ) AS index
          FROM videos
          LEFT JOIN channels ON channels.id = videos.channel_id
          LEFT JOIN songs ON songs.id = videos.song_id
          LEFT JOIN events ON events.id = videos.event_id
          LEFT JOIN dancer_videos ON dancer_videos.video_id = videos.id
          LEFT JOIN dancers ON dancers.id = dancer_videos.dancer_id
          LEFT JOIN orchestras ON orchestras.id = songs.orchestra_id
          GROUP BY videos.id
        ) AS query
        WHERE videos.id IN (?) AND query.id = videos.id
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
