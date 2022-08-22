class Follower < ApplicationRecord
  include FullNameable
  include Reviewable
  include Normalizeable

  validates :name, presence: true, uniqueness: true

  has_many :videos
  has_many :leader, through: :videos
  has_many :song, through: :videos

  after_create :find_videos

  def find_videos
    Video.with_dancer_name_in_title(name).find_each do |video|
      video.update(follower: self)
    end
  end

  def search_data
    { name: }
  end
end
