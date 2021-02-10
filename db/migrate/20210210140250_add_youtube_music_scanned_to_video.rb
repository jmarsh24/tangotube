class AddYoutubeMusicScannedToVideo < ActiveRecord::Migration[6.1]
  def change
    add_column :videos, :scanned_youtube_music, :boolean, default: false
  end
end
