class AddSlugToSongs < ActiveRecord::Migration[7.0]
  def change
    add_column :songs, :slug, :string
    add_index :events, :slug, unique: true
  end
end
