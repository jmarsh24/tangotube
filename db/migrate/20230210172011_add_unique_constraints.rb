# frozen_string_literal: true

class AddUniqueConstraints < ActiveRecord::Migration[7.0]
  def change
    add_index :videos, :youtube_id, unique: true
    add_index :playlists, :slug, unique: true
  end
end
