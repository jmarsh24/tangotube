class AddColumnsToSongs < ActiveRecord::Migration[6.0]
  def change
    add_column :songs, :artist_2, :string
    add_column :songs, :composer, :string
    add_column :songs, :author, :string
    add_column :songs, :date, :date
    add_column :songs, :last_name_search, :string
  end
end
