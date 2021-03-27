class Follower < ApplicationRecord
  include FullNameable
  include Reviewable

  validates :name, presence: true, uniqueness: true

  has_many :videos
  has_many :leader, through: :videos
  has_many :song, through: :videos
end
