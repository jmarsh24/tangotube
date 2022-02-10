class Song < ApplicationRecord
  validates :genre, presence: true
  validates :title, presence: true
  validates :artist, presence: true

  has_many :videos, dependent: :nullify
  has_many :leader, through: :videos
  has_many :follower, through: :videos

  # song match scopes
  scope :title_match,
        ->(query) { where("unaccent(title) ILIKE unaccent(?)", "%#{query}%") }

  def full_title
    "#{title.titleize} - #{artist.split("'").map(&:titleize).join("'")} - #{genre.titleize}"
  end

  def translate_to_english
    translation = DeepL.translate lyrics, "ES", "EN"
    update(lyrics_en: translation.text)
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
