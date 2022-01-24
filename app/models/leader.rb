class Leader < ApplicationRecord
  include FullNameable
  include Reviewable
  include Normalizeable

  validates :name, presence: true, uniqueness: true

  has_many :videos
  has_many :follower, through: :videos
  has_many :song, through: :videos
end
