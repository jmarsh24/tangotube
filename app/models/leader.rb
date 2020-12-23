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
  actions :all
  validates :name, presence: true, uniqueness: true

  has_many :videos, dependent: :destroy
  has_many :followers, dependent: :destroy
end
