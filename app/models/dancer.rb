# frozen_string_literal: true

# == Schema Information
#
# Table name: dancers
#
#  id           :bigint           not null, primary key
#  name         :string           not null
#  user_id      :bigint
#  bio          :text
#  slug         :string
#  reviewed     :boolean          default(FALSE), not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  videos_count :integer          default(0), not null
#  gender       :enum
#  search_text  :text
#  match_terms  :text             default([]), is an Array
#  nickname     :string
#
class Dancer < ApplicationRecord
  belongs_to :user, optional: true
  has_many :dancer_videos, dependent: :destroy
  has_many :videos, through: :dancer_videos
  has_many :orchestras, through: :videos
  has_many :songs, through: :videos
  has_many :recent_searches, as: :searchable, dependent: :destroy

  has_many :couples, dependent: :destroy
  has_many :couple_videos, through: :couples
  has_many :partners, through: :couples
  has_many :performances, through: :videos

  has_one_attached :profile_image
  has_one_attached :cover_image
  enum gender: {male: "male", female: "female"}

  normalizes :match_terms, with: ->(match_terms) {
                                   match_terms.map { I18n.transliterate(_1).strip.downcase }
                                 }
  normalizes :name, with: ->(name) { name.strip }

  after_validation :set_slug, only: [:create, :update]
  before_save :update_search_text
  before_validation :update_normalized_name
  after_save { couples.touch_all }

  scope :reviewed, -> { where(reviewed: true) }
  scope :unreviewed, -> { where(reviewed: false) }
  scope :search, ->(search_term) {
                   max_videos_count = Dancer.maximum(:videos_count).to_f
                   normalized_term = TextNormalizer.normalize(search_term)
                   terms = normalized_term.split

                   where_conditions = terms.map { "? <% search_text" }.join(" OR ")

                   order_sql = <<-SQL
    0.5 * (1 - ("dancers"."search_text" <-> '#{normalized_term}')) +
    0.5 * (videos_count::float / #{max_videos_count}) DESC
                   SQL

                   Dancer
                     .where(where_conditions, *terms)
                     .order(Arel.sql(order_sql))
                 }

  scope :most_popular, -> { order(videos_count: :desc) }
  scope :match_by_name, ->(text:, threshold: 0.75) {
                          where("word_similarity(normalized_name, :text) > :threshold", text:, threshold:)
                        }
  scope :match_by_terms, ->(text:, threshold: 0.75) {
    where("EXISTS (
      SELECT 1
      FROM unnest(match_terms) as term
      WHERE word_similarity(term, :text) > :threshold
    )", text:, threshold: 0.75)
  }

  def update_search_text
    self.search_text = I18n.transliterate([name, nickname].join(" "))
      .downcase
      .strip
      .gsub(/\s+/, " ")
  end

  def update_video_matches
    search_terms = [TextNormalizer.normalize(name)]
    search_terms.concat(match_terms.map { |term| TextNormalizer.normalize(term) }) if match_terms.present?
    matching_videos = Video.title_match(search_terms)

    matching_videos.find_each do |video|
      role = (gender == "male") ? "leader" : "follower"
      DancerVideo.find_or_create_by(dancer: self, video:, role:)
    end
  end

  def to_param
    "#{id}-#{slug}"
  end

  def update_normalized_name
    self.normalized_name = I18n.transliterate(name).downcase.strip
  end

  private

  def set_slug
    self.slug = name.parameterize
  end
end
