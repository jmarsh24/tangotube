# == Schema Information
#
# Table name: followers
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
  factory :followers do
    name { 'MyText' }
    first_name { 'MyText' }
    last_name { 'MyText' }
    nickname { 'MyText' }
    reviewed { true }
  end
end
