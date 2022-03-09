FactoryBot.define do
  factory :clip do
    start_seconds { 1 }
    end_seconds { 1 }
    title { "MyText" }
    playback_rate { "9.99" }
    tags { "MyString" }
    user { nil }
    video { nil }
  end
end
