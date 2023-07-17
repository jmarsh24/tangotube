# frozen_string_literal: true

# == Schema Information
#
# Table name: videos
#
#  id                  :bigint           not null, primary key
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  title               :text
#  youtube_id          :string           not null
#  description         :string
#  duration            :integer
#  view_count          :integer
#  song_id             :bigint
#  acr_response_code   :integer
#  channel_id          :bigint
#  hidden              :boolean          default(FALSE)
#  hd                  :boolean          default(FALSE)
#  popularity          :integer          default(0)
#  like_count          :integer          default(0)
#  event_id            :bigint
#  click_count         :integer          default(0)
#  featured            :boolean          default(FALSE)
#  index               :text
#  metadata            :jsonb
#  tags                :text             default([]), is an Array
#  imported_at         :datetime
#  upload_date         :date
#  upload_date_year    :integer
#  youtube_view_count  :integer
#  youtube_like_count  :integer
#  youtube_tags        :text             default([]), is an Array
#  metadata_updated_at :datetime
#  normalized_title    :string
#
class Video < ApplicationRecord
  belongs_to :song, optional: true, counter_cache: true
  belongs_to :channel, optional: false, counter_cache: true
  belongs_to :event, optional: true, counter_cache: true
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
  has_many :video_searches

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
  scope :dancer, ->(value) { joins(:dancers).where(dancers: {slug: value}) }
  scope :genre, ->(value) {
    subquery = Song.where("LOWER(genre) = ?", value.downcase).select(:id)
    where(song_id: subquery)
  }
  scope :has_leader, -> { where("EXISTS (SELECT 1 FROM dancer_videos WHERE dancer_videos.video_id = videos.id AND role = 'leader')") }
  scope :has_follower, -> { where("EXISTS (SELECT 1 FROM dancer_videos WHERE dancer_videos.video_id = videos.id AND role = 'follower')") }
  scope :hd, ->(value) { where(hd: value) }
  scope :hidden, -> { where(hidden: true) }
  scope :not_hidden, -> { where(hidden: false) }
  scope :liked, ->(user) { joins(:likes).where(likes: {likeable_type: "Video", user_id: user.id}) }
  scope :orchestra, ->(value) {
                      subquery = Song.joins(:orchestra).where(orchestras: {slug: value}).select(:id)
                      where(song_id: subquery)
                    }
  scope :song, ->(value) {
                 subquery = Song.where(slug: value).select(:id)
                 where(song_id: subquery)
               }
  scope :event, ->(value) {
                  subquery = Event.where(slug: value).select(:id)
                  where(event_id: subquery)
                }
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
  scope :fuzzy_titles, ->(terms) do
                         terms = [terms] unless terms.is_a?(Array)
                         query = terms.map { |term| sanitize_sql(["word_similarity(?, normalized_title) > 0.95", term]) }.join(" OR ")
                         where(query)
                       end
  scope :most_popular, -> { order(click_count: :desc) }
  scope :unrecognized_music, -> { where(acr_response_code: [nil]).or(where.not(acr_response_code: [0, 1001])) }
  scope :trending, -> {
    joins(:video_searches)
      .order("video_searches.score DESC")
  }

  class << self
    def search(terms)
      Video.find(VideoSearch.search(terms))
    end

    def index_query
      INDEX_QUERY
    end

    def search_includes
      [
        :channel,
        :song,
        :performance,
        dancer_videos: :dancer,
        thumbnail_attachment: :blob
      ]
    end
  end

  def featured?
    featured
  end

  def to_param
    youtube_id || id
  end

  def hd_duration_data
    return if duration.blank?

    Time.at(duration).utc.strftime("#{hd? ? "HD " : ""}%M:%S")
  end
end
