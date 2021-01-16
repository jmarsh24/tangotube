class AddUniqueIndexToMatVideos < ActiveRecord::Migration[6.1]
  def change
    add_index :mat_videos, :video_id, unique: true
  end
end
