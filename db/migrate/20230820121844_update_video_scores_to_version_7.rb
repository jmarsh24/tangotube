class UpdateVideoScoresToVersion7 < ActiveRecord::Migration[7.0]
  def change
    update_view :video_scores, version: 7, revert_to_version: 6, materialized: true
  end
end
