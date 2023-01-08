# frozen_string_literal: true

class CreateCoupleVideos < ActiveRecord::Migration[7.0]
  def change
    create_table :couple_videos do |t|
      t.belongs_to :video, null: false, foreign_key: true
      t.belongs_to :couple, null: false, foreign_key: true

      t.timestamps
    end
    add_index :couple_videos, [:video_id, :couple_id], unique: true
  end
end
