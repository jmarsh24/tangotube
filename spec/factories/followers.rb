FactoryBot.define do
  factory :follower do
    sequence(:name) { |n| "Jane Doe #{n}" }
  end
end
