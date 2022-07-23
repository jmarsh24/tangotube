FactoryBot.define do
  factory :performance do
    event { nil }
    date { "2022-07-22" }
    video { nil }
    videos_count { 1 }
    position { 1 }
    slug { "MyString" }
  end
end
