class AddAcrCloud < ActiveRecord::Migration[6.0]
  def change
    add_column :videos, :confidence_score, :string
    add_column :videos, :acrid, :string
    add_column :videos, :spotify_album_id, :string
    add_column :videos, :spotify_album_name, :string
    add_column :videos, :spotify_artist_id, :string
    add_column :videos, :spotify_artist_id_2, :string
    add_column :videos, :spotify_artist_name, :string
    add_column :videos, :spotify_artist_name_2, :string
    add_column :videos, :spotify_track_id, :string
    add_column :videos, :spotify_track_name, :string
    add_column :videos, :youtube_song_id, :string
  end
end
