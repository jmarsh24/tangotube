# frozen_string_literal: true

# == Schema Information
#
# Table name: yt_comments
#
#  id                :bigint           not null, primary key
#  video_id          :bigint           not null
#  body              :text             not null
#  user_name         :text             not null
#  like_count        :integer          default(0), not null
#  date              :date             not null
#  channel_id        :string           not null
#  profile_image_url :string           not null
#  youtube_id        :string           not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
FactoryBot.define do
  factory :yt_comment do
  end
end
