class Couple < ApplicationRecord
  belongs_to :dancer_a, class_name: "Dancer"
  belongs_to :dancer_b, class_name: "Dancer"

  has_one_attached :profile_image
  has_one_attached :cover_image

  validate :dancers_not_the_same
  validates :dancer_a, uniqueness: { scope: :dancer_b, message: "There already exists a couple with these dancers." }


  def dancers_not_the_same
    @errors.add(:base, "The dancers should be not be the same") if dancer_a == dancer_b
  end
end

