# == Schema Information
#
# Table name: channels
#
#  id                    :bigint           not null, primary key
#  title                 :string
#  channel_id            :string
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  thumbnail_url         :string
#  imported              :boolean          default(FALSE)
#  imported_videos_count :integer          default(0)
#  total_videos_count    :integer          default(0)
#  yt_api_pull_count     :integer          default(0)
#  reviewed              :boolean          default(FALSE)
#
class Channel < ApplicationRecord
  include Reviewable
  include Importable

  validates :channel_id, presence: true, uniqueness: true

  has_many :videos, dependent: :destroy

  scope :title_search, lambda { |query|
                         where("unaccent(title) ILIKE unaccent(?)",
                               "%#{query}%")
                       }

  class << self
    def update_imported_video_counts
      all.find_each do |channel|
        channel.update(imported_videos_count: channel.videos.count)
      end
    end

    def update_import_status
      where("imported_videos_count < total_videos_count").find_each do |channel|
        channel.update(imported: false)
      end
    end
  end
end
