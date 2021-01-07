class AddIndexArtistAndGenreToSongs < ActiveRecord::Migration[6.0]
  def change
    add_index(:songs, :genre)
  end
end
