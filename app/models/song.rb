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
#  display_title     :string
#  spotify_track_id  :string
#
class Song < ApplicationRecord
  STOP_WORDS = {
    en: ["a", "an", "and", "are", "as", "at", "be", "but", "by", "for", "if", "in", "into", "is", "it", "no", "not", "of", "on", "or", "such", "that", "the", "their", "then", "there", "these", "they", "this", "to", "was", "will", "with"],
    es: ["un", "una", "unos", "unas", "y", "o", "pero", "por", "para", "como", "al", "de", "del", "los", "las"]
  }.freeze

  validates :title, presence: true
  validates :artist, presence: true

  belongs_to :orchestra, optional: true
  has_many :videos, dependent: :nullify, counter_cache: true
  has_many :leaders, through: :videos
  has_many :followers, through: :videos

  before_save :set_display_title
  after_validation :set_slug, only: [:create, :update]

  scope :sort_by_popularity, -> { order(popularity: :desc) }
  scope :popularity, -> { where.not(popularity: nil) }
  scope :active, -> { where(active: true) }
  scope :not_active, -> { where(active: false) }
  scope :search, ->(terms) do
                   sanitized_terms = Array.wrap(terms).map { |term| remove_stop_words(term).tr("*", "").downcase }
                   return none if sanitized_terms.empty?

                   where_clause = sanitized_terms.map do |term|
                     "(word_similarity(?, title) > 0.3 OR word_similarity(?, artist) > 0.3 OR word_similarity(?, genre) > 0.3)"
                   end.join(" OR ")

                   where(where_clause, *sanitized_terms.flat_map { |term| ["%#{term}%", "%#{term}%", "%#{term}%"] })
                     .order(Arel.sql(
                       "videos_count DESC, similarity(title, '#{sanitized_terms.first}') DESC"
                     ))
                 end

  def full_title
    title_part = title&.titleize
    artist_part = artist&.split("'")&.map(&:titleize)&.join("'")
    genre_part = genre&.titleize

    [title_part, artist_part, genre_part].compact.join(" - ")
  end

  def translate_to_english
    translation = DeepL.translate lyrics, "ES", "EN"
    update(lyrics_en: translation.text)
  end

  def set_slug
    self.slug = "#{title}-#{artist}".parameterize
  end

  def to_param
    slug
  end

  class << self
    def index_query
      INDEX_QUERY
    end

    def missing_english_translation
      where.not(lyrics: nil).where(lyrics_en: nil)
    end
  end

  private

  def custom_titleize(name)
    name&.split("'")&.map(&:titleize)&.join("'")
  end

  def set_display_title
    self.display_title = [title&.titleize, custom_titleize(orchestra&.name), genre&.titleize, date&.year].compact.join(" - ")
  end

  def self.remove_stop_words(term)
    languages = [:en, :es]
    stop_words = languages.map { |language| STOP_WORDS[language] }.compact.flatten
    return term unless stop_words

    term.split.reject { |word| stop_words.include?(word) }.join(" ")
  end
end
