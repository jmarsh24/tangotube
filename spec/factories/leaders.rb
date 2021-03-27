FactoryBot.define do
  factory :leader do
    sequence(:name) { |n| "John Doe #{n}" }
  end
end
