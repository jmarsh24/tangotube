# frozen_string_literal: true

class AddUniqueIndexToDancerVideo < ActiveRecord::Migration[7.0]
  def change
    add_index :dancer_videos, [:dancer_id, :video_id], unique: true
  end
end
