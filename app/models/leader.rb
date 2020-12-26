# == Schema Information
#
# Table name: leaders
#
#  id         :bigint           not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  reviewed   :boolean
#

class Leader < ApplicationRecord
  validates :name, presence: true, uniqueness: true

  has_many :videos

  scope :reviewed,     ->   { where.not(reviewed: nil) }
  scope :not_reviewed, ->   { where(reviewed: nil) }

end
