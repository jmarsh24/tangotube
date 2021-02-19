# == Schema Information
#
# Table name: leaders
#
#  id         :bigint           not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  reviewed   :boolean
#  nickname   :string
#  first_name :string
#  last_name  :string
#

class Leader < ApplicationRecord
  validates :name, presence: true, uniqueness: true

  has_many :videos
  has_many :follower, through: :videos
  has_many :song, through: :videos

  scope :reviewed,     ->   { where(reviewed: true) }
  scope :not_reviewed, ->   { where(reviewed: false) }

  def full_name
    first_name.present? && last_name.present? ? "#{first_name} #{last_name}" : name
  end
end
