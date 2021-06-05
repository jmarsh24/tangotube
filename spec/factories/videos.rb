FactoryBot.define do
  factory :video do
    channel
    
    sequence(:youtube_id) { |n| "fancy_youtube_slug#{n}" }
    performance_date { "2017-10-26" }
    
    trait :display do
      duration { "100" }
      upload_date { "2017-10-26" }
    end

    factory :watched_video do      
      after(:create) do |video|
        ahoy = Ahoy::Tracker.new
        ahoy.track( "Video View", youtube_id: video.youtube_id )
      end
    end
  end
end
