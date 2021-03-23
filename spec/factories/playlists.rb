FactoryBot.define do
  factory :playlist do
    playlist_id { Faker::String.random(length: 12) }
  end
end
