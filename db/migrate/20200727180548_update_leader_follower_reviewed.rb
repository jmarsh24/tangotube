class UpdateLeaderFollowerReviewed < ActiveRecord::Migration[6.0]
  def change
    add_column :leaders, :reviewed, :boolean
    add_column :followers, :reviewed, :boolean
  end
end
