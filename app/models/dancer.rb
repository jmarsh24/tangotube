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
#  nick_name    :string
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

  has_many :couples, dependent: :destroy
  has_many :partners, through: :couples
  has_many :performances, through: :videos

  has_one_attached :profile_image
  has_one_attached :cover_image
  enum gender: {male: "male", female: "female"}

  after_validation :set_slug, only: [:create, :update]

  scope :search, ->(term) { where("CONCAT_WS(' ', first_name, last_name) ILIKE unaccent(?)", "%#{term}%") }
  scope :reviewed, -> { where(reviewed: true) }
  scope :unreviewed, -> { where(reviewed: false) }

  def full_name
    "#{first_name} #{last_name}"
  end

  def to_param
    "#{id}-#{slug}"
  end

  def self.ransackable_attributes(auth_object = nil)
    ["bio", "created_at", "first_name", "gender", "id", "last_name", "middle_name", "name", "nick_name", "reviewed", "slug", "updated_at", "user_id", "videos_count"]
  end

  private

  def set_slug
    self.slug = full_name.parameterize
  end
end
