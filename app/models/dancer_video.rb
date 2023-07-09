# frozen_string_literal: true

# == Schema Information
#
# Table name: dancer_videos
#
#  id         :bigint           not null, primary key
#  dancer_id  :bigint
#  video_id   :bigint
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  role       :enum
#
class DancerVideo < ApplicationRecord
  belongs_to :dancer, counter_cache: :videos_count
  belongs_to :video
  counter_culture :dancer, column_name: "videos_count"

  validates :dancer, uniqueness: {scope: :video}
  enum role: {neither: "neither", leader: "leader", follower: "follower", both: "both"}
end
