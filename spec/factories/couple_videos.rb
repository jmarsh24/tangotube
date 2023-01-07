# == Schema Information
#
# Table name: couple_videos
#
#  id         :bigint           not null, primary key
#  video_id   :bigint           not null
#  couple_id  :bigint           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
  factory :couple_video do
    video { nil }
    couple { nil }
  end
end
