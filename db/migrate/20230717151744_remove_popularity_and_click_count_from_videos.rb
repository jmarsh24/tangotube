class RemovePopularityAndClickCountFromVideos < ActiveRecord::Migration[7.0]
  def change
    remove_column :videos, :popularity, :integer
    remove_column :videos, :click_count, :integer
  end
end
