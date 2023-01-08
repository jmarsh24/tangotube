# frozen_string_literal: true

# == Schema Information
#
# Table name: clips
#
#  id            :bigint           not null, primary key
#  start_seconds :integer          not null
#  end_seconds   :integer          not null
#  title         :text
#  playback_rate :decimal(5, 3)    default(1.0)
#  user_id       :bigint           not null
#  video_id      :bigint           not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  giphy_id      :string
#
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
