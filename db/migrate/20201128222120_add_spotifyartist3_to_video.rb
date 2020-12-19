class AddSpotifyartist3ToVideo < ActiveRecord::Migration[6.0]
  def change
    add_column :videos, :spotify_artist_name_3, :string
  end
end
