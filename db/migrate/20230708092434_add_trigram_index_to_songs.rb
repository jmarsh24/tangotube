# frozen_string_literal: true

class AddTrigramIndexToSongs < ActiveRecord::Migration[7.0]
  def up
    remove_index :songs, :artist
    remove_index :songs, :title
    remove_index :songs, :genre
    add_index :songs, :artist, using: :gin, opclass: :gin_trgm_ops
    add_index :songs, :title, using: :gin, opclass: :gin_trgm_ops
    add_index :songs, :genre, using: :gin, opclass: :gin_trgm_ops
  end

  def down
    add_index :songs, :artist
    add_index :songs, :title
    add_index :songs, :genre
    remove_index :songs, :artist
    remove_index :songs, :title
    remove_index :songs, :genre
  end
end
