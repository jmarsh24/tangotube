class UpdateVideoScoresToVersion8 < ActiveRecord::Migration[7.0]
  def change
    update_view :video_scores, version: 8, revert_to_version: 7, materialized: true
  end
end
