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
  before_save :update_imported, if: :count_changed?

  include Reviewable
  include Importable

  validates :channel_id, presence: true, uniqueness: true

  has_many :videos, dependent: :destroy

  scope :title_search, lambda { |query|
                         where("unaccent(title) ILIKE unaccent(?)",
                               "%#{query}%")
                       }

  private

  def update_imported
    self.imported = videos_count >= total_videos_count
  end

  def count_changed?
    total_videos_count_changed? || videos_count_changed?
  end
end
