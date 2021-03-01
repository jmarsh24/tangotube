# == Schema Information
#
# Table name: channels
#
#  id                    :bigint           not null, primary key
#  title                 :string
#  channel_id            :string
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  thumbnail_url         :string
#  imported              :boolean          default(FALSE)
#  imported_videos_count :integer          default(0)
#  total_videos_count    :integer          default(0)
#  yt_api_pull_count     :integer          default(0)
#  reviewed              :boolean          default(FALSE)
#

FactoryBot.define do
  factory :channel do
    channel_id { "MyText" }
    title { "MyText" }
    imported { true }
    thumbnail_url { "MyText" }
  end

  factory :random_channel do
    title { Faker::Name.first_name }
    thumbnail_url { Faker::Name.last_name }
    name { Faker::Name.first_name + " " + Faker::Name.last_name }
  end
end
