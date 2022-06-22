class Channel < ApplicationRecord
  include Reviewable
  include Importable

  has_many :videos, dependent: :destroy

  after_save { videos.find_each(&:reindex) }

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
