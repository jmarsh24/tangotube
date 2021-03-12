# == Schema Information
#
# Table name: songs
#
#  id               :bigint           not null, primary key
#  genre            :string
#  title            :string
#  artist           :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  artist_2         :string
#  composer         :string
#  author           :string
#  date             :date
#  last_name_search :string
#  occur_count      :integer          default(0)
#  popularity       :integer          default(0)
#  active           :boolean          default(TRUE)
#  lyrics           :text
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
  scope :title_match, ->(model_attribute) { where("unaccent(title) ILIKE unaccent(?)", "%#{model_attribute}%") }

  scope :full_title_search, lambda { |query|
                              where("unaccent(songs.title) ILIKE unaccent(:query) OR
                                    unaccent(artist) ILIKE unaccent(:query) OR
                                    unaccent(genre) ILIKE unaccent(:query)",
                                    query: "%#{query}%").references(:song)
                            }

  def full_title
    "#{title.titleize} - #{artist.titleize} - #{genre.titleize}"
  end

  class << self
    def set_all_popularity_values
      max_count = Song.maximum(:videos_count).to_f
      update_all("popularity = CAST(videos_count AS FLOAT) / #{max_count} * 100.0")
    end
  end
end
