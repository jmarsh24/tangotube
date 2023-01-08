# frozen_string_literal: true

class AddVideosCountToCouples < ActiveRecord::Migration[7.0]
  def self.up
    add_column :couples, :videos_count, :integer, null: false, default: 0
  end

  def self.down
    remove_column :couples, :videos_count
  end
end
