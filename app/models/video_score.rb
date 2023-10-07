# frozen_string_literal: true

# == Schema Information
#
# Table name: video_scores
#
#  video_id    :bigint           primary key
#  video_title :text
#  score_1     :float
#  score_2     :float
#  score_3     :float
#  score_4     :float
#  score_5     :float
#  score_6     :float
#
class VideoScore < ApplicationRecord
  self.primary_key = :video_id
  belongs_to :video

  class << self
    def refresh
      Scenic.database.refresh_materialized_view("video_scores", concurrently: true, cascade: false)
    end
  end

  def readonly?
    true
  end
end
