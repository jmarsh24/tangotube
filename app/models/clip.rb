# == Schema Information
#
# Table name: clips
#
#  id            :bigint           not null, primary key
#  start_seconds :integer          not null
#  end_seconds   :integer          not null
#  title         :text
#  playback_rate :decimal(5, 3)    default(1.0)
#  user_id       :bigint           not null
#  video_id      :bigint           not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  giphy_id      :string
#
class Clip < ApplicationRecord
  acts_as_taggable_on :tags

  belongs_to :user
  belongs_to :video

  validates :title, presence: true
  validates :start_seconds, presence: true
  validates :end_seconds, presence: true

  after_create :create_gif_job

  def create_gif
    gif = Clip::Gif.create( { youtube_id: video.youtube_id,
                              start_time: start_seconds,
                              end_time: end_seconds } )
    self.giphy_id = gif.id
    save
  end

  def create_gif_job
    CreateGifJob.perform_async(id)
  end

  def giphy_url
    "https://media1.giphy.com/media/#{giphy_id}/200.webp"
  end
end
