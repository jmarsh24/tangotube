FactoryBot.define do
  factory :song do
    genre { Faker::Music.genre }
    title { Faker::Music::RockBand.song }
    artist { Faker::Music::RockBand.name }
  end
end
