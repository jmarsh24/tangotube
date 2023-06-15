# frozen_string_literal: true

class AddPlaylistVideos < ActiveRecord::Migration[7.1]
  def change
    create_table :playlist_videos do |t|
      t.references :playlist, null: false, foreign_key: true
      t.references :video, null: false, foreign_key: true
      t.integer :position

      t.timestamps
    end

    add_index :playlist_videos, [:playlist_id, :video_id], unique: true
  end
end
