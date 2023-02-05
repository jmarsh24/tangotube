class RemoveLeaderFollowerFromVideos < ActiveRecord::Migration[7.0]
  def change
    remove_column :videos, :leader_id
    remove_column :videos, :follower_id
  end
end
