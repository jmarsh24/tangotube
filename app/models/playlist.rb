class Playlist < ApplicationRecord
  validates :slug, presence: true, uniqueness: true

  has_many :videos

end
