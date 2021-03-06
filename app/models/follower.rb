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
  include FullNameable
  validates :name, presence: true, uniqueness: true

  has_many :videos
  has_many :leader, through: :videos
  has_many :song, through: :videos
end
