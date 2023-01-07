# == Schema Information
#
# Table name: performance_videos
#
#  id             :bigint           not null, primary key
#  video_id       :bigint
#  performance_id :bigint
#  position       :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
FactoryBot.define do
  factory :performance_video do
    
  end
end
