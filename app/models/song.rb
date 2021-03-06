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
    # FIXME; way too many lines in this method. What does it do, a method should do one or two manipulation max!
    # Break that down in smaller parts.
    def calc_song_popularity
      occur_num = Video.group(:song_id).count
      max_value = occur_num.values.max
      popularity = occur_num.transform_values { |v| (v.to_f / max_value * 100).round }

      occur_num.each do |key, value|
        song = Song.find(key)
        song.update(occur_count: value)
      end

      popularity.each do |key, value|
        song = Song.find(key)
        song.update(popularity: value)
      end
    end
  end
end
