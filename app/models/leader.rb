class Leader < ApplicationRecord
  include FullNameable
  include Reviewable
  include Normalizeable

  validates :name, presence: true, uniqueness: true

  has_many :videos
  has_many :follower, through: :videos
  has_many :song, through: :videos

  after_create :find_videos
  after_commit { videos.find_each(&:reindex!) }

  def find_videos
    Video.with_dancer_name_in_title(name).find_each do |video|
      video.update(leader: self)
    end
  end

end
