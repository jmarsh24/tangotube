FactoryBot.define do
  factory :event do
    title { Faker::String.random(length: 10) }
    city { Faker::Address.city }
    country { Faker::Address.country }
  end
end
