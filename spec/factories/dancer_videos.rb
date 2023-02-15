FactoryBot.define do
  factory :dancer
  factory :video

  factory :dancer_video do
    trait :neither do
      association :dancer, factory: :dancer
      role { :neither }
    end

    trait :leader do
      association :dancer, factory: :dancer
      role { :leader }
    end

    trait :follower do
      association :dancer, factory: :dancer
      role { :follower }
    end

    trait :both do
      association :dancer, factory: :dancer
      role { :both }
    end
  end
end
