# frozen_string_literal: true

class AddVideosCountToDancers < ActiveRecord::Migration[7.0]
  def self.up
    add_column :dancers, :videos_count, :integer, null: false, default: 0
  end

  def self.down
    remove_column :dancers, :videos_count
  end
end
