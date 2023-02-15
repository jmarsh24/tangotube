FactoryBot.define do
  factory :channel do
    channel_id { Faker::Number.number(digits: 10) }
    title { Faker::Name.name }

    trait :inactive do
      active { false }
    end
  end
end
