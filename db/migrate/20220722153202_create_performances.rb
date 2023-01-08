# frozen_string_literal: true

class CreatePerformances < ActiveRecord::Migration[7.0]
  def change
    create_table :performances do |t|
      t.date :date
      t.integer :videos_count
      t.string :slug

      t.timestamps
    end
  end
end
