# == Schema Information
#
# Table name: followers
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

class Follower < ApplicationRecord
  validates :name, presence: true, uniqueness: true

  has_many :videos

  scope :reviewed,     ->   { where(reviewed: true) }
  scope :not_reviewed, ->   { where(reviewed: false) }

end
