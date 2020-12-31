class AddPopularityToSongs < ActiveRecord::Migration[6.0]
  def change
    add_column :songs, :occur_count, :int, default: 0
    add_column :songs, :popularity, :int, default: 0
    add_column :songs, :active, :boolean, default: true
  end
end
