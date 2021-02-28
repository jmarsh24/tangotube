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
  scope :title_match, ->(model_attribute) { where('unaccent(title) ILIKE unaccent(?)', "%#{model_attribute}%") }

  scope :full_title_search, lambda { |query|
                              where('unaccent(songs.title) ILIKE unaccent(:query) OR
                                    unaccent(artist) ILIKE unaccent(:query) OR
                                    unaccent(genre) ILIKE unaccent(:query)',
                                    query: "%#{query}%").references(:song)
                            }

  def full_title
    "#{title.titleize} - #{artist.titleize} - #{genre.titleize}"
  end

  class << self
    def scrape_lyrics
      (16_400..20_000).each do |id|
        puts "Page Number: #{id}"

        response = Faraday.get("https://www.el-recodo.com/music?id=#{id}&lang=en")

        doc = Nokogiri::HTML(response.body)

        lyrics = doc.css('p#geniusText').text if doc.css('p#geniusText').present?

        date = doc.css('div.list-group.lead a')[0].text.strip.split[1] if doc.css('div.list-group.lead a')[0].present?

        if doc.css('div.list-group.lead a')[1].present?
          title = doc.css('div.list-group.lead a')[1].text.strip.split[1..-1].join(' ')
        end

        if doc.css('div.list-group.lead a')[3].present?
          artist = doc.css('div.list-group.lead a')[3].text.strip.split[1..-1].join(' ')
        end

        if lyrics.present?
          song = Song.where('title ILIKE ? AND artist ILIKE ?', title, artist)
          song.update(lyrics: lyrics)
        end
      end
    end

    # FIXME; way too many lines in this method. What does it do, a method should do one or two manipulation max!
    # Break that down in smaller parts.
    def calc_song_popularity
      Song.column_defaults["popularity"]
      Song.column_defaults["occur_count"]

      occur_num = Video.pluck(:song_id).compact!.tally
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
