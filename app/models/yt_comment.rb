# == Schema Information
#
# Table name: yt_comments
#
#  id                :bigint           not null, primary key
#  video_id          :bigint           not null
#  body              :text             not null
#  user_name         :text             not null
#  like_count        :integer          default(0), not null
#  date              :date             not null
#  channel_id        :string           not null
#  profile_image_url :string           not null
#  youtube_id        :string           not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
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
