class AddLyricsEnToSongs < ActiveRecord::Migration[6.1]
  def change
    add_column :songs, :lyrics_en, :string
  end
end
