# frozen_string_literal: true

class UpdateVideoScoresToVersion2 < ActiveRecord::Migration[7.0]
  def change
    update_view :video_scores, version: 2, revert_to_version: 1, materialized: true
  end
end
