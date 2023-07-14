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
  validates :title, presence: true
  validates :artist, presence: true

  belongs_to :orchestra, optional: true, counter_cache: true
  has_many :videos, dependent: :nullify, counter_cache: true
  has_many :leaders, through: :videos
  has_many :followers, through: :videos

  before_save :set_display_title
  after_validation :set_slug, only: [:create, :update]

  scope :sort_by_popularity, -> { order(popularity: :desc) }
  scope :popularity, -> { where.not(popularity: nil) }
  scope :active, -> { where(active: true) }
  scope :not_active, -> { where(active: false) }
  scope :most_popular, -> { order(videos_count: :desc) }
  scope :search, ->(search_term) {
    search_terms = search_term.split(" ").map { |term| TextNormalizer.normalize(term) }
    quoted_search_terms = search_terms.map { |term| ActiveRecord::Base.connection.quote_string(term) }

    similarity_expr = search_terms.each_with_index.map do |term, index|
      title_similarity = "similarity(title, '#{quoted_search_terms[index]}')"
      artist_similarity = "similarity(artist, '#{quoted_search_terms[index]}')"
      genre_similarity = "similarity(genre, '#{quoted_search_terms[index]}')"

      "#{title_similarity} * 2 + #{artist_similarity} * 1.5 + #{genre_similarity}"
    end.join(" + ")

    search_conditions = search_terms.map { |term|
      "(title % '#{term}' OR artist % '#{term}' OR genre % '#{term}')"
    }.join(" OR ")

    select_expr = "songs.*, #{similarity_expr} AS relevance_score"
    order_expr = "relevance_score DESC, videos_count DESC"

    where(search_conditions)
      .select(select_expr)
      .order(Arel.sql(order_expr))
  }

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
end
