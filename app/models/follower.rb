# == Schema Information
#
# Table name: followers
#
#  id         :bigint           not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  reviewed   :boolean
#

class Follower < ApplicationRecord
  validates :name, presence: true, uniqueness: true

  has_many :videos

end
