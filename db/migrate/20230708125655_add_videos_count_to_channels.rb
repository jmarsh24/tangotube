# frozen_string_literal: true

class AddVideosCountToChannels < ActiveRecord::Migration[7.0]
  def change
    add_column :channels, :videos_count, :integer, default: 0
    add_index :channels, :videos_count
  end
end
