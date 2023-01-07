# == Schema Information
#
# Table name: channels
#
#  id                    :bigint           not null, primary key
#  title                 :string
#  channel_id            :string           not null
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  thumbnail_url         :string
#  imported              :boolean          default(FALSE)
#  imported_videos_count :integer          default(0)
#  total_videos_count    :integer          default(0)
#  yt_api_pull_count     :integer          default(0)
#  reviewed              :boolean          default(FALSE)
#  videos_count          :integer          default(0), not null
#  active                :boolean          default(TRUE)
#
class Channel < ApplicationRecord
  include Reviewable
  include Importable

  has_many :videos, dependent: :destroy

  validates :channel_id, presence: true, uniqueness: true

  before_save :update_imported, if: :count_changed?
  after_save :destroy_all_videos, unless: :active?

  scope :title_search,
        lambda { |query|
          where("unaccent(title) ILIKE unaccent(?)", "%#{query}%")
        }

  def destroy_all_videos
    return "This Channel doesn't have any videos" if videos.nil?
    videos.find_each(&:destroy)
  end

  private

  def update_imported
   self.imported = videos_count >= total_videos_count
  end

  def count_changed?
    total_videos_count_changed? || videos_count_changed?
  end
end
