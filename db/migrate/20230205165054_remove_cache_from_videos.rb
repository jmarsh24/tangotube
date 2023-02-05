class RemoveCacheFromVideos < ActiveRecord::Migration[7.0]
  def change
    remove_column :videos, :cached_scoped_votes_total, :integer, default: 0
    remove_column :videos, :cached_scoped_votes_score, :integer, default: 0
    remove_column :videos, :cached_scoped_votes_up, :integer, default: 0
    remove_column :videos, :cached_scoped_votes_down, :integer, default: 0
    remove_column :videos, :cached_scoped_weighted_score, :integer, default: 0
    remove_column :videos, :cached_scoped_weighted_total, :integer, default: 0
    remove_column :videos, :cached_scoped_weighted_average, :float, default: 0.0
  end
end
