class Orchestra < ApplicationRecord
  has_many :songs, dependent: :destroy
  has_many :videos, through: :songs
  has_many :dancers, through: :videos
  has_many :couples, through: :videos

  validates :name, presence: true, uniqueness: true

  has_one_attached :profile_image
  has_one_attached :cover_image

  after_validation :set_slug, only: [:create, :update]

  def to_param
    "#{id}-#{slug}"
  end

  private

  def set_slug
    self.slug = name.parameterize
  end
end
