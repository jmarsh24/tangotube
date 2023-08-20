class AddCounterCacheLikesWatchesFeaturesToVideos < ActiveRecord::Migration[7.0]
  def change
    add_column :videos, :likes_count, :integer, default: 0
    add_column :videos, :watches_count, :integer, default: 0
    add_column :videos, :features_count, :integer, default: 0
  end
end
