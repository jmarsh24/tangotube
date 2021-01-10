# == Schema Information
#
# Table name: leaders
#
#  id         :bigint           not null, primary key
#  name       :string           not null
#  nickname   :string
#  reviewed   :boolean
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_leaders_on_name  (name)
#

class Leader < ApplicationRecord
  validates :name, presence: true, uniqueness: true

  has_many :videos

  scope :reviewed,     ->   { where(reviewed: true) }
  scope :not_reviewed, ->   { where(reviewed: false) }
end
