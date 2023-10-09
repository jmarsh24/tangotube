class AddSearchTextToSongs < ActiveRecord::Migration[7.1]
  def change
    add_column :songs, :search_text, :text
    add_index :songs, :search_text, using: :gist, opclass: :gist_trgm_ops
  end
end
