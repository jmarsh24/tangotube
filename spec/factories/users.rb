FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "J.Doe#{n}@example.com" }
    password { Faker::Internet.password(min_length: 10, max_length: 20) }
  end
end
