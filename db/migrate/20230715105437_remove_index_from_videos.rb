class RemoveIndexFromVideos < ActiveRecord::Migration[7.0]
  def change
    remove_column :videos, :index, :text
  end
end
