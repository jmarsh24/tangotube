class Song < ApplicationRecord
  include PgSearch::Model
  multisearchable against: [:title, :artist]

  validates :genre, presence: true
  validates :title, presence: true
  validates :artist, presence: true

  belongs_to :orchestra
  has_many :videos, dependent: :nullify
  has_many :leader, through: :videos
  has_many :follower, through: :videos
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

    def rebuild_pg_search_documents
      find_each { |record| record.update_pg_search_document }
    end
  end
end
