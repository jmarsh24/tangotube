class AddIndexToPerformance < ActiveRecord::Migration[7.0]
  def change
    add_index :performance_videos, [:performance_id, :video_id]
  end
end
