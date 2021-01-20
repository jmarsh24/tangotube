class Channel < ApplicationRecord
  validates :channel_id, presence: true, uniqueness: true

  has_many :videos, dependent: :destroy

  scope :imported,     ->   { where(imported: true) }
  scope :not_imported, ->   { where(imported: false) }
end
