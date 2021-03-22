# == Schema Information
#
# Table name: songs
#
#  id               :bigint           not null,
#  primary key
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
FactoryBot.define do
  factory :song do
    genre { "TANGO" }
    title { "La mentirosa" }
    artist { "Anibal Troilo" }
  end

  factory :random_song do
    genre { Faker::Music.genre }
    title { Faker::Music::RockBand.song }
    artist { Faker::Name.name }
    artist_2 { Faker::Name.name }
    composer { Faker::Name.name }
    author { Faker::Name.name }
    date { Faker::Date.between(from: "1900-01-01", to: Date.today) }
    popularity { Faker::Number.between(from: 1, to: 100) }
    active { true }
    lyrics { Faker::Quote.famous_last_words }
    last_name_search { artist.last }
  end
end
