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
    genre { Faker::Music.genre }
    title { Faker::Music::RockBand.song  }
    artist { Faker::Music::RockBand.name }
  end
end
