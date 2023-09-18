# frozen_string_literal: true

# == Schema Information
#
# Table name: dancers
#
#  id           :bigint           not null, primary key
#  name         :string           not null
#  first_name   :string
#  last_name    :string
#  middle_name  :string
#  nick_name    :string           default([]), is an Array
#  user_id      :bigint
#  bio          :text
#  slug         :string
#  reviewed     :boolean          default(FALSE), not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  videos_count :integer          default(0), not null
#  gender       :enum
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

  after_validation :set_slug, only: [:create, :update]

  scope :reviewed, -> { where(reviewed: true) }
  scope :unreviewed, -> { where(reviewed: false) }
  scope :search, ->(search_term) {
    max_videos_count = Dancer.maximum(:videos_count).to_f

    terms = TextNormalizer.normalize(search_term).split

    where_conditions = terms.map { "unaccent(dancers.name) % unaccent(?)" }.join(" OR ")
    order_sql = <<-SQL
      0.5 * (1 - ("dancers"."name" <-> '#{search_term}')) + 0.5 * (videos_count::float / #{max_videos_count}) DESC
    SQL

    Dancer
      .where(where_conditions, *terms)
      .order(Arel.sql(order_sql))
  }

  scope :most_popular, -> { order(videos_count: :desc) }

  def update_video_matches
    search_terms = [TextNormalizer.normalize(name)]
    search_terms.concat(nick_name.map { |term| TextNormalizer.normalize(term) }) if nick_name.present?
    matching_videos = Video.fuzzy_titles(search_terms)

    matching_videos.find_each do |video|
      role = (gender == "male") ? "leader" : "follower"
      DancerVideo.find_or_create_by(dancer: self, video:, role:)
    end
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def to_param
    "#{id}-#{slug}"
  end

  private

  def set_slug
    self.slug = name.parameterize
  end
end
