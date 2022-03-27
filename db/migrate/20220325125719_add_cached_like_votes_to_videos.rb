class AddCachedLikeVotesToVideos < ActiveRecord::Migration[7.0]
  def change
    change_table :videos do |t|
      t.integer :cached_scoped_like_votes_total, default: 0
      t.integer :cached_scoped_like_votes_score, default: 0
      t.integer :cached_scoped_like_votes_up, default: 0
      t.integer :cached_scoped_like_votes_down, default: 0
      t.integer :cached_weighted_like_score, default: 0
      t.integer :cached_weighted_like_total, default: 0
      t.float :cached_weighted_like_average, default: 0.0
    end

    remove_column :videos, :cached_votes_total, :integer
    remove_column :videos, :cached_votes_score, :integer
    remove_column :videos, :cached_votes_up, :integer
    remove_column :videos, :cached_votes_down, :integer
    remove_column :videos, :cached_weighted_score, :integer
    remove_column :videos, :cached_weighted_total, :integer
    remove_column :videos, :cached_weighted_average, :float
  end
end
