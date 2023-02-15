FactoryBot.define do
  factory :user do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }

    trait :male do
      gender { 0 }
    end

    trait :female do
      gender { 1 }
    end
  end
end
