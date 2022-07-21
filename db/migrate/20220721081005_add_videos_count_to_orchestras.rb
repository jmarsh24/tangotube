class AddVideosCountToOrchestras < ActiveRecord::Migration[7.0]
  def self.up
    add_column :orchestras, :videos_count, :integer, null: false, default: 0
  end

  def self.down
    remove_column :orchestras, :videos_count
  end
end
