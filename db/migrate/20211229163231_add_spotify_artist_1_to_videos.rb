class AddSpotifyArtist1ToVideos < ActiveRecord::Migration[6.1]
  def change
    add_column :videos, :spotify_artist_id_1, :string, if_not_exists: true
    add_column :videos, :spotify_artist_name_1, :string, if_not_exists: true
  end
end
