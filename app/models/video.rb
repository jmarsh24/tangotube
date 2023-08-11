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
#  like_count          :integer          default(0)
#  event_id            :bigint
#  featured            :boolean          default(FALSE)
#  metadata            :jsonb
#  tags                :text             default([]), is an Array
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
  has_many :video_searches, dependent: :destroy
  has_many :video_scores, dependent: :destroy

  has_one_attached :thumbnail

  attribute :metadata, ExternalVideoImport::Metadata.to_type
  validates :youtube_id, presence: true, uniqueness: true

  scope :channel, ->(channel_id) { joins(:channel).where(channel: {channel_id:}) }
  scope :exclude_youtube_id, ->(youtube_id) { where.not(youtube_id:) }
  scope :featured, -> { where(featured: true) }
  scope :not_featured, -> { where(featured: false) }
  scope :follower, ->(slug) {
                     joins("JOIN dancer_videos AS follower_dancer_videos ON follower_dancer_videos.video_id = videos.id")
                       .joins("JOIN dancers AS follower_dancers ON follower_dancers.id = follower_dancer_videos.dancer_id")
                       .where(follower_dancers: {slug:}, follower_dancer_videos: {role: "follower"})
                   }
  scope :leader, ->(slug) {
                   joins("JOIN dancer_videos AS leader_dancer_videos ON leader_dancer_videos.video_id = videos.id")
                     .joins("JOIN dancers AS leader_dancers ON leader_dancers.id = leader_dancer_videos.dancer_id")
                     .where(leader_dancers: {slug:}, leader_dancer_videos: {role: "leader"})
                 }
  scope :has_leader, -> { where("EXISTS (SELECT 1 FROM dancer_videos WHERE dancer_videos.video_id = videos.id AND role = 'leader')") }
  scope :has_follower, -> { where("EXISTS (SELECT 1 FROM dancer_videos WHERE dancer_videos.video_id = videos.id AND role = 'follower')") }
  scope :dancer, ->(slug) { joins(:dancers).where(dancers: {slug:}) }
  scope :genre, ->(value) { joins(:song).where("LOWER(genre) = ?", value.downcase) }
  scope :hd, ->(hd) { where(hd:) }
  scope :hidden, -> { where(hidden: true) }
  scope :not_hidden, -> { where(hidden: false) }
  scope :liked, ->(user) { joins(:likes).where(likes: {likeable_type: "Video", user_id: user.id}) }
  scope :orchestra, ->(slug) { joins(song: :orchestra).where(orchestras: {slug:}) }
  scope :song, ->(slug) { joins(:song).where(songs: {slug:}) }
  scope :event, ->(slug) { joins(:event).where(events: {slug:}) }
  scope :couple, ->(slug) { joins(:couples).where(couples: {slug:}) }
  scope :watched, ->(user_id) { joins(:watches).where(watches: {user_id:}) }
  scope :not_watched, ->(user_id) { where.not(id: Watch.where(user_id:).select(:video_id)) }
  scope :year, ->(upload_date_year) { where(upload_date_year:) }
  scope :within_week_of, ->(date) { where(upload_date: (date - 7.days)..(date + 7.days)) }
  scope :most_popular, -> { trending_1 }
  scope :trending_1, -> { joins(:video_scores).order("video_scores.score_1 DESC") }
  scope :trending_2, -> { joins(:video_scores).order("video_scores.score_2 DESC") }
  scope :trending_3, -> { joins(:video_scores).order("video_scores.score_3 DESC") }
  scope :trending_4, -> { joins(:video_scores).order("video_scores.score_4 DESC") }
  scope :trending_5, -> { joins(:video_scores).order("video_scores.score_5 DESC") }
  scope :fuzzy_titles, ->(terms) do
                         terms = [terms] unless terms.is_a?(Array)
                         query = terms.map { |term| sanitize_sql(["word_similarity(?, normalized_title) > 0.95", term]) }.join(" OR ")
                         where(query)
                       end
  scope :music_recognized, -> { where(acr_response_code: 0) }
  scope :music_unrecognized, -> { where(acr_response_code: [nil]).or(where.not(acr_response_code: [0, 1001])) }

  before_validation :normalize_title

  class << self
    def search(query)
      video_ids = VideoSearch.search(query)
      joins(:video_searches)
        .where(id: video_ids)
        .order("video_searches.score DESC")
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

  def normalize_title
    self.normalized_title = TextNormalizer.normalize(title)
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
