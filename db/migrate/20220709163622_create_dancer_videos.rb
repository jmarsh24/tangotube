# frozen_string_literal: true

class CreateDancerVideos < ActiveRecord::Migration[7.0]
  def change
    create_table :dancer_videos do |t|
      t.belongs_to :dancer, index: true
      t.belongs_to :video, index: true
      t.integer :role, null: false, default: 0

      t.timestamps
    end
  end
end
