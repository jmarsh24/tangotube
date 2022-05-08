class Clip < ApplicationRecord
  belongs_to :user
  belongs_to :video

  validates :title, presence: true
  validates :start_seconds, presence: true
  validates :end_seconds, presence: true


  after_create :create_gif unless :has_gif?

  def create_gif
    gif = Clip::Gif.create( { youtube_id: video.youtube_id,
                              start_time: start_seconds,
                              end_time: end_seconds } )
    self.giphy_id = gif.id
    save
  end

  def has_gif?
    giphy_id.present?
  end
end
