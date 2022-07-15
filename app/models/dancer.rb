class Dancer < ApplicationRecord
  belongs_to :user, optional: true
  has_many :dancer_videos, dependent: :destroy
  has_many :videos, through: :dancer_videos
  has_many :dancer_a_couples, foreign_key: "dancer_a_id", class_name: "Couple", dependent: :destroy
  has_many :dancer_b_couples, foreign_key: "dancer_b_id", class_name: "Couple", dependent: :destroy
  has_one_attached :profile_image
  has_one_attached :cover_image

  # validates :first_name, presence: true
  # validates :last_name, presence: true
  # validates :reviewed, presence: true

  # searchkick word_middle: [:full_name]

  after_validation :set_slug, only: [:create, :update]
  # after_save :find_videos

  # def find_videos
  #   Video.with_dancer_name_in_title(full_name).find_each do |video|
  #     DancerVideo.create(video:, role: , dancer:)
  #   end
  # end

  def couples
    Couple.where("dancer_a_id = ? OR dancer_b_id = ?", id, id)
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def set_slug
    self.slug = "#{first_name}-#{last_name}".parameterize
  end
end
