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
#

class Song < ApplicationRecord
  include PgSearch::Model

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
  scope :title_match, ->(_model_attribute) { 'unaccent(title) ILIKE unaccent(model_attribute)' }

  pg_search_scope :search,
                  against: %i[title artist genre],
                  ignoring: :accents

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
  end
end
