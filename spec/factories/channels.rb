# frozen_string_literal: true

# == Schema Information
#
# Table name: channels
#
#  id                    :bigint           not null, primary key
#  title                 :string
#  channel_id            :string           not null
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  thumbnail_url         :string
#  imported              :boolean          default(FALSE)
#  imported_videos_count :integer          default(0)
#  total_videos_count    :integer          default(0)
#  yt_api_pull_count     :integer          default(0)
#  reviewed              :boolean          default(FALSE)
#  videos_count          :integer          default(0), not null
#  active                :boolean          default(TRUE)
#
FactoryBot.define do
  factory :channel do
    sequence(:channel_id) { |n| "fancy_youtube_slug#{n}" }
  end
end
