class AddClickCountToVideos < ActiveRecord::Migration[6.1]
  def change
    add_column :videos, :click_count, :integer, default: 0
  end
end
