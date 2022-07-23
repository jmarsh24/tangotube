class Performance < ApplicationRecord
  has_many :performance_videos
  has_many :videos, through: :performance_videos
end
