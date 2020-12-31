class AddSongScannedToVideos < ActiveRecord::Migration[6.0]
  def change
    add_column :videos, :scanned_song, :boolean, default: false
  end
end
