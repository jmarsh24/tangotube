class UpdateVideoScoresToVersion9 < ActiveRecord::Migration[7.0]
  def change
    update_view :video_scores, version: 9, revert_to_version: 8, materialized: true
    add_index :video_scores, :score_6
  end
end
