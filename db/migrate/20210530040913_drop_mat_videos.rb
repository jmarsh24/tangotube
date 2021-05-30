class DropMatVideos < ActiveRecord::Migration[6.1]
  def change
    drop_view :mat_videos, materialized: true
  end
end
