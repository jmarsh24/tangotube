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
  include FullNameable
  include Reviewable

  validates :name, presence: true, uniqueness: true

  has_many :videos
  has_many :follower, through: :videos
  has_many :song, through: :videos
end
