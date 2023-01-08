# frozen_string_literal: true

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
class PerformanceVideo < ApplicationRecord
  belongs_to :video
  belongs_to :performance

  counter_culture :performance, column_name: "videos_count"
end
