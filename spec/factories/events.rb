FactoryBot.define do
  factory :event do
    sequence(:title) { |n| "Fancy event #{n}" }
    city { Faker::Address.city }
    country { Faker::Address.country }
  end
end
