# == Schema Information
#
# Table name: songs
#
#  id               :bigint           not null, primary key
#  active           :boolean          default(TRUE)
#  artist           :string
#  artist_2         :string
#  author           :string
#  composer         :string
#  date             :date
#  genre            :string
#  last_name_search :string
#  occur_count      :integer          default(0)
#  popularity       :integer          default(0)
#  title            :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
# Indexes
#
#  index_songs_on_artist  (artist)
#  index_songs_on_genre   (genre)
#  index_songs_on_title   (title)
#

class Song < ApplicationRecord
  validates :genre, presence: true
  validates :title, presence: true
  validates :artist, presence: true

  has_many :videos

  # active admin scopes
  scope :sort_by_popularity,   -> { order(popularity: :desc) }
  scope :filter_by_popularity, -> { where.not(popularity: [false, nil]) }
  scope :filter_by_active,     -> { where(active: true) }
  scope :filter_by_not_active, -> { where(active: false) }



  # song match scopes
  scope :title_match, ->(_model_attribute) { 'unaccent(title) ILIKE unaccent(model_attribute)' }
end
