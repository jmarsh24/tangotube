# frozen_string_literal: true

class CreatePerformanceVideos < ActiveRecord::Migration[7.0]
  def change
    create_table :performance_videos do |t|
      t.belongs_to :video
      t.belongs_to :performance
      t.integer :position
      t.timestamps
    end
  end
end
