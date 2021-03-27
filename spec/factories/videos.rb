FactoryBot.define do
  factory :video do
    channel
    sequence(:youtube_id) { |n| "fancy_youtube_slug#{n}" }
  end
end
