# frozen_string_literal: true

class UpdateVideoScoresToVersion11 < ActiveRecord::Migration[7.1]
  def change
    update_view :video_scores, version: 11, revert_to_version: 10, materialized: true
  end
end
