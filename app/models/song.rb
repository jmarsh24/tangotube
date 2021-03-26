# == Schema Information
#
# Table name: songs
#
#  id                :bigint           not null, primary key
#  genre             :string
#  title             :string
#  artist            :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  artist_2          :string
#  composer          :string
#  author            :string
#  date              :date
#  last_name_search  :string
#  occur_count       :integer          default(0)
#  popularity        :integer          default(0)
#  active            :boolean          default(TRUE)
#  lyrics            :text
#  el_recodo_song_id :integer
#  videos_count      :integer          default(0), not null
#

class Song < ApplicationRecord
  validates :genre, presence: true
  validates :title, presence: true
  validates :artist, presence: true

  has_many :videos, dependent: :nullify
  has_many :leader, through: :videos
  has_many :follower, through: :videos

  # active admin scopes
  scope :sort_by_popularity, -> { order(popularity: :desc) }
  scope :filter_by_active, -> { where(active: true) }
  scope :filter_by_not_active, -> { where(active: false) }

  # song match scopes
  scope :title_match, ->(query) { where("unaccent(title) ILIKE unaccent(?)", "%#{query}%") }

  def full_title
    "#{title.titleize} - #{artist.split("'").map(&:titleize).join("'")} - #{genre.titleize}"
  end

  class << self
    def full_title_search(query)
      words = query.to_s.strip.split
      words.reduce(all) do |combined_scope, word|
        combined_scope.where("unaccent(songs.title) ILIKE unaccent(:query) OR
                              unaccent(regexp_replace(artist, '''', '', 'g')) ILIKE unaccent(:query) OR
                              unaccent(genre) ILIKE unaccent(:query) OR
                              unaccent(artist) ILIKE unaccent(:query)", query: "%#{word}%").references(:song)
      end
    end
  end
end
