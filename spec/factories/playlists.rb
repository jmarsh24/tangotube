FactoryBot.define do
  factory :playlist do
    sequence(:slug) { |n| "Slug#{n}" }
  end
end
