FactoryBot.define do
  factory :channel do
    sequence(:channel_id) { |n| "fancy_youtube_slug#{n}" }
  end
end
