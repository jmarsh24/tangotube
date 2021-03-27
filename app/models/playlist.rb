class Playlist < ApplicationRecord
  include Importable

  validates :slug, presence: true, uniqueness: true
end
