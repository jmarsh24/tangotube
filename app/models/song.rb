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
  scope :search, ->(terms) {
                   Array.wrap(terms).map { |term| TextNormalizer.normalize(term) }
                     .reduce(self) do |scope, term|
                       normalized_term = term.downcase
                       quoted_term = ActiveRecord::Base.connection.quote_string(normalized_term)

                       dancers_similarity = "(similarity(dancers_names, '#{quoted_term}') * 0.35)"
                       channels_similarity = "(similarity(channels_title, '#{quoted_term}') * 0.05)"
                       songs_similarity = "(similarity(songs_title, '#{quoted_term}') * 0.25)"
                       artist_similarity = "(similarity(songs_artist, '#{quoted_term}') * 0.05)"
                       orchestras_similarity = "(similarity(orchestras_name, '#{quoted_term}') * 0.15)"
                       events_city_similarity = "(similarity(events_city, '#{quoted_term}') * 0.05)"
                       events_title_similarity = "(similarity(events_title, '#{quoted_term}') * 0.1)"
                       events_country_similarity = "(similarity(events_country, '#{quoted_term}') * 0.05)"
                       videos_similarity = "(similarity(videos_title, '#{quoted_term}') * 0.15)"

                       total_score = "(#{dancers_similarity} + #{channels_similarity} + #{songs_similarity} + #{artist_similarity} + #{orchestras_similarity} + #{events_city_similarity} + #{events_title_similarity} + #{events_country_similarity} + #{videos_similarity}) as score"

                       scope.select("video_id, #{total_score}")
                         .where("? % dancers_names OR ? % channels_title OR ? % songs_title OR ? % songs_artist OR ? % orchestras_name OR ? % events_city OR ? % events_title OR ? % events_country OR ? % videos_title", quoted_term, quoted_term, quoted_term, quoted_term, quoted_term, quoted_term, quoted_term, quoted_term, quoted_term)
                     end
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
