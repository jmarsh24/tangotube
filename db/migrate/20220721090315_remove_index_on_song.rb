class RemoveIndexOnSong < ActiveRecord::Migration[7.0]
  def change
    remove_index :songs, :slug
  end
end
