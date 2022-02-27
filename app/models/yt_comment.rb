class YtComment < ApplicationRecord
  belongs_to :video

  validates :body, presence: true
  validates :date, presence: true
  validates :like_count, presence: true
  validates :profile_image_url, presence: true
  validates :channel_id, presence: true
  validates :youtube_id, presence: true
  validates :user_name, presence: true

end
