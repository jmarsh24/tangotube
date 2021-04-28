class Playlist < ApplicationRecord
  include Importable
  include Reviewable

  validates :slug, presence: true, uniqueness: true
end
