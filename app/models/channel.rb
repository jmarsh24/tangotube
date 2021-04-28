class Channel < ApplicationRecord
  include Reviewable
  include Importable

  has_many :videos, dependent: :destroy

  validates :channel_id, presence: true, uniqueness: true

  before_save :update_imported, if: :count_changed?

  scope :title_search,
        lambda { |query|
          where('unaccent(title) ILIKE unaccent(?)', "%#{query}%")
        }

  private

  def update_imported
    self.imported = videos_count >= total_videos_count
  end

  def count_changed?
    total_videos_count_changed? || videos_count_changed?
  end
end
