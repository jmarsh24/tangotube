# frozen_string_literal: true

class AddDisplayTitleToSongs < ActiveRecord::Migration[7.0]
  def change
    add_column :songs, :display_title, :string
  end
end
