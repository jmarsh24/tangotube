# == Schema Information
#
# Table name: leaders
#
#  id         :bigint           not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  reviewed   :boolean
#  nickname   :string
#  first_name :string
#  last_name  :string
#
FactoryBot.define do
  factory :leader do
    name { "Carlitos Espinoza" }
    first_name { "Carlitos" }
    last_name { "Espinoza" }
    nickname { "Carlitos" }
    reviewed { true }
  end

  factory :random_leader do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    name { "#{Faker::Name.first_name} #{Faker::Name.last_name}" }
  end
end
