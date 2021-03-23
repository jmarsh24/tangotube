FactoryBot.define do
  factory :playlist do
    slug { Faker::String.random(length: 12) }
  end
end
