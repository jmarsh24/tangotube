FactoryBot.define do
  factory :video do
    channel
    sequence(:youtube_id) { |n| "fancy_youtube_slug#{n}" }
    trait :display do
      duration { '100' }
      upload_date { '2017-10-26' }
    end
  end
end
