FactoryBot.define do
  factory :dancer do
    first_name { "MyString" }
    last_name { "MyString" }
    middle_name { "MyString" }
    nick_name { "MyString" }
    user { nil }
    bio { "MyText" }
    slug { "MyString" }
    reviewed { false }
    couple { nil }
  end
end
