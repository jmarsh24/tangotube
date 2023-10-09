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
  has_many :videos, dependent: :nullify
  has_many :leaders, through: :videos
  has_many :followers, through: :videos
  has_many :recent_searches, as: :searchable, dependent: :destroy

  before_save :set_display_title
  before_save :update_search_text
  after_validation :set_slug, only: [:create, :update]

  scope :sort_by_popularity, -> { order(popularity: :desc) }
  scope :popularity, -> { where.not(popularity: nil) }
  scope :active, -> { where(active: true) }
  scope :not_active, -> { where(active: false) }
  scope :most_popular, -> { order(videos_count: :desc) }
  scope :search, ->(search_term) {
                   normalized_term = normalize(search_term)

                   order_sql = <<-SQL
    0.5 * (1 - ("songs"."search_text" <-> #{ActiveRecord::Base.connection.quote(normalized_term)})) + 
    0.5 * (videos_count::float / (SELECT MAX(videos_count) FROM songs)) DESC
                   SQL

                   Song
                     .where("? <% search_text", normalized_term)
                     .order(Arel.sql(order_sql))
                 }

  class << self
    def normalize(*strings)
      combined_string = strings.join(" ")
      I18n.transliterate(combined_string)
        .downcase
        .strip
        .gsub(/\s+/, " ")
    end
  end

  def update_search_text
    self.search_text = Song.normalize(title, artist, genre, orchestra&.name, date&.year)
  end

  def full_title
    title_part = title&.titleize
    max_length = 20
    title_part = (title_part.length > max_length) ? "#{title_part[0...max_length - 3]}..." : title_part

    artist_part = artist&.split("'")&.map(&:titleize)&.join("'")
    genre_part = genre&.titleize

    [title_part, artist_part, genre_part].compact.join(" - ")
  end

  def display_title
    max_length = 48
    (title.length > max_length) ? "#{title[0...max_length - 3]}..." : title
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

  def update_spotify_track_id
    track = Spotify::TrackFinder.new.search_track("#{title} #{artist}")
    return if track.nil?
    update(spotify_track_id: track.dig("id"))
  end

  class << self
    def index_query
      INDEX_QUERY
    end

    def missing_english_translation
      where.not(lyrics: nil).where(lyrics_en: nil)
    end
  end

  def formatted_artist
    artist&.split("'")&.map(&:titleize)&.join("'")
  end

  private

  def set_display_title
    self.display_title = [title&.titleize, orchestra&.name || artist, genre&.titleize, date&.year].compact.join(" - ")
  end
end
