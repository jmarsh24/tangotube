class UpdateVideoScoresToVersion4 < ActiveRecord::Migration[7.0]
  def change
    update_view :video_scores, version: 4, revert_to_version: 3, materialized: true
  end
end
