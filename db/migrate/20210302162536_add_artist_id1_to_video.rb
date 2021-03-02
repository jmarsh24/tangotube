class AddArtistId1ToVideo < ActiveRecord::Migration[6.1]
  def change
    add_column :videos, :spotify_artist_id_1, :string
    add_column :videos, :spotify_artist_name_1, :string
  end
end
