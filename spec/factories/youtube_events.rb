FactoryBot.define do
  factory :youtube_event do
    data { "MyText" }
    status { 1 }
    processing_errors { "MyString" }
  end
end
