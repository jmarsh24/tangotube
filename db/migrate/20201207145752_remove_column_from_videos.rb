class RemoveColumnFromVideos < ActiveRecord::Migration[6.0]
  def change
    remove_column :videos, :duration, :int
  end
end
