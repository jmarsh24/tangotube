# == Schema Information
#
# Table name: followers
#
#  id           :bigint           not null, primary key
#  name         :string           not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  reviewed     :boolean
#  nickname     :string
#  first_name   :string
#  last_name    :string
#  videos_count :integer          default(0), not null
#
FactoryBot.define do
  factory :follower do
    name { Faker::Name.name }
  end
end
