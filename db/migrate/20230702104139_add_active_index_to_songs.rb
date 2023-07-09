# frozen_string_literal: true

class AddActiveIndexToSongs < ActiveRecord::Migration[7.0]
  def change
    add_index :songs, :active
    add_index :songs, :videos_count
  end
end
