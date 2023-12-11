class ModifySongAttributes < ActiveRecord::Migration[7.1]
  disable_ddl_transaction!

  def change
    add_column :songs, :normalized_title, :string
    add_column :songs, :normalized_artist, :string
    add_index :songs, :normalized_title, using: :gin, opclass: :gin_trgm_ops, algorithm: :concurrently
    add_index :songs, :normalized_artist, using: :gin, opclass: :gin_trgm_ops, algorithm: :concurrently
    add_index :songs, :artist_2, using: :gin, opclass: :gin_trgm_ops, algorithm: :concurrently
  end
end
