# frozen_string_literal: true

class UpdateVideoScoresToVersion3 < ActiveRecord::Migration[7.0]
  def change
    update_view :video_scores, version: 3, revert_to_version: 2, materialized: true
  end
end
