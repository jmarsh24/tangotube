class AddIndexToSongs < ActiveRecord::Migration[6.0]
  def change
    add_index(:songs, :title)
  end
end
