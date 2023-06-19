# frozen_string_literal: true

# == Schema Information
#
# Table name: videos
#
#  id                  :bigint           not null, primary key
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  youtube_id          :string
#  song_id             :bigint
#  channel_id          :bigint
#  hidden              :boolean          default(FALSE)
#  popularity          :integer          default(0)
#  event_id            :bigint
#  click_count         :integer          default(0)
#  featured            :boolean          default(FALSE)
#  index               :text
#  metadata            :jsonb
#  imported_at         :datetime
#  upload_date         :date
#  upload_date_year    :integer
#  title               :text
#  description         :text
#  hd                  :boolean
#  youtube_view_count  :integer
#  youtube_like_count  :integer
#  youtube_tags        :text             default([]), is an Array
#  duration            :integer
#  metadata_updated_at :datetime
#
class Video < ApplicationRecord
  include Filterable
  include Indexable
  include Presentable

  INDEX_QUERY = <<~SQL.squish.freeze
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

  belongs_to :song, optional: true
  belongs_to :channel, optional: false
  belongs_to :event, optional: true
  has_many :clips, dependent: :destroy
  has_many :dancer_videos, dependent: :destroy
  has_many :dancers, through: :dancer_videos
  has_many :leader_roles, -> { where(role: :leader) }, class_name: "DancerVideo", inverse_of: :video, dependent: :destroy
  has_many :leaders, through: :leader_roles, source: :dancer
  has_many :follower_roles, -> { where(role: :follower) }, class_name: "DancerVideo", inverse_of: :video, dependent: :destroy
  has_many :followers, through: :follower_roles, source: :dancer
  has_many :couple_videos, dependent: :destroy
  has_many :couples, through: :couple_videos
  has_many :watches, dependent: :destroy
  has_many :watchers, through: :watches, source: :user
  has_many :likes, as: :likeable, dependent: :destroy
  has_many :liking_users, through: :likes, source: :user
  has_one :orchestra, through: :song
  has_one :performance_video, dependent: :destroy
  has_one :performance, through: :performance_video
  has_one_attached :thumbnail

  attribute :metadata, ExternalVideoImport::Metadata.to_type
  validates :youtube_id, presence: true, uniqueness: true

  scope :channel, ->(value) { joins(:channel).where(channels: {channel_id: value}) }
  scope :exclude_youtube_id, ->(value) { where.not(youtube_id: value) }
  scope :featured, -> { where(featured: true) }
  scope :not_featured, -> { where(featured: false) }
  scope :follower, ->(value) {
                     joins("JOIN dancer_videos AS follower_dancer_videos ON follower_dancer_videos.video_id = videos.id")
                       .joins("JOIN dancers AS follower_dancers ON follower_dancers.id = follower_dancer_videos.dancer_id")
                       .where(follower_dancers: {slug: value}, follower_dancer_videos: {role: "follower"})
                   }
  scope :leader, ->(value) {
                   joins("JOIN dancer_videos AS leader_dancer_videos ON leader_dancer_videos.video_id = videos.id")
                     .joins("JOIN dancers AS leader_dancers ON leader_dancers.id = leader_dancer_videos.dancer_id")
                     .where(leader_dancers: {slug: value}, leader_dancer_videos: {role: "leader"})
                 }
  scope :dancer, ->(value) {
    joins(:dancers)
      .where(dancers: {slug: value})
  }
  scope :genre, ->(value) { joins(:song).where("LOWER(songs.genre) = ?", value.downcase) }
  scope :has_leader, -> { where("EXISTS (SELECT 1 FROM dancer_videos WHERE dancer_videos.video_id = videos.id AND role = 'leader')") }
  scope :has_follower, -> { where("EXISTS (SELECT 1 FROM dancer_videos WHERE dancer_videos.video_id = videos.id AND role = 'follower')") }
  scope :hd, ->(value) { where(hd: value) }
  scope :hidden, -> { where(hidden: true) }
  scope :not_hidden, -> { where(hidden: false) }
  scope :liked, ->(user) { joins(:likes).where(likes: {likeable_type: "Video", user_id: user.id}) }
  scope :orchestra, ->(value) { joins(:song, :orchestra).where(orchestras: {slug: value}) }
  scope :song, ->(value) { joins(:song).where(songs: {slug: value}) }
  scope :event, ->(value) { joins(:event).where(events: {slug: value}) }
  scope :watched, ->(user) {
    subquery = Watch.where(user_id: user.id).group(:video_id).select(:video_id)
    where(id: subquery)
  }
  scope :not_watched, ->(user) {
                        subquery = Watch.select(:video_id).where(user_id: user.id)
                        where.not(id: subquery)
                      }

  scope :watch_history, ->(user) {
    subquery = Watch.where(user_id: user.id).group(:video_id).select(:video_id)
    where(id: subquery)
  }
  scope :year, ->(value) { where(upload_date_year: value) }
  scope :within_week_of, ->(date) { where(upload_date: (date - 7.days)..(date + 7.days)) }
  scope :searched, ->(term) { where("title ILIKE ?", "%#{term}%") }

  class << self
    def index_query
      INDEX_QUERY
    end

    def search_includes
      [
        :channel,
        :dancer_videos,
        :dancers,
        :song,
        :event,
        :performance_video,
        :performance,
        thumbnail_attachment: :blob,
        dancers: {profile_image_attachment: :blob},
        event: {profile_image_attachment: :blob},
        song: {orchestra: {profile_image_attachment: :blob}}
      ]
    end
  end

  def clicked!
    increment(:click_count)
    save!
  end

  def featured?
    featured
  end

  def to_param
    youtube_id || id
  end
end
