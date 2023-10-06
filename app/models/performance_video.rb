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
  belongs_to :video, touch: true
  belongs_to :performance, counter_cache: :videos_count

  delegate :videos_count, to: :performance, prefix: true

  def total
    [position, performance.videos_count].max
  end

  def formatted_position
    position.present? ? "#{position} / #{total}" : ""
  end
end
