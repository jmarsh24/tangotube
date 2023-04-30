# frozen_string_literal: true

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
#  lyrics_en         :string
#  slug              :string
#  orchestra_id      :bigint
#
class Song < ApplicationRecord
  validates :title, presence: true
  validates :artist, presence: true

  belongs_to :orchestra, optional: true
  has_many :videos, dependent: :nullify
  has_many :leaders, through: :videos
  has_many :followers, through: :videos
  counter_culture :orchestra, column_name: "songs_count"

  after_validation :set_slug, only: [:create, :update]

  scope :sort_by_popularity, -> { order(popularity: :desc) }
  scope :filter_by_popularity, -> { where.not(popularity: nil) }
  scope :filter_by_active, -> { where(active: true) }
  scope :filter_by_not_active, -> { where(active: false) }
  scope :title_match,
    ->(query) { where("unaccent(title) ILIKE unaccent(?)", "%#{query}%") }

  def full_title
    "#{title.titleize} - #{artist.split("'").map(&:titleize).join("'")} - #{genre.titleize}"
  end

  def translate_to_english
    translation = DeepL.translate lyrics, "ES", "EN"
    update(lyrics_en: translation.text)
  end

  def set_slug
    self.slug = "#{title}-#{artist}".parameterize
  end

  class << self
    def full_title_search(query)
      words = query.to_s.strip.split
      words.reduce(all) do |combined_scope, word|
        combined_scope
          .where(
            "unaccent(songs.title) ILIKE unaccent(:query) OR
              unaccent(regexp_replace(artist, '''', '', 'g')) ILIKE unaccent(:query) OR
              unaccent(genre) ILIKE unaccent(:query) OR
              unaccent(artist) ILIKE unaccent(:query)",
            query: "%#{word}%"
          )
          .references(:song)
      end
    end

    def missing_english_translation
      where.not(lyrics: nil).where(lyrics_en: nil)
    end
  end
end
