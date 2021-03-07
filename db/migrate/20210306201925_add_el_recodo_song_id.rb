class AddElRecodoSongId < ActiveRecord::Migration[6.1]
  def change
    add_column :songs, :el_recodo_song_id, :int
  end
end
