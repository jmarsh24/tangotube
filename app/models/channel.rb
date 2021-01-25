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
#
class Channel < ApplicationRecord
  validates :channel_id, presence: true, uniqueness: true

  has_many :videos, dependent: :destroy

  scope :imported,     ->   { where(imported: true) }
  scope :not_imported, ->   { where(imported: false) }
end
