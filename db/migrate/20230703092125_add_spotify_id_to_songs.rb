class AddSpotifyIdToSongs < ActiveRecord::Migration[7.0]
  def change
    add_column :songs, :spotify_track_id, :string
  end
end
