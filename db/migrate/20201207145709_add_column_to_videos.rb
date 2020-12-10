class AddColumnToVideos < ActiveRecord::Migration[6.0]
  def change
    add_column :videos, :length, :interval
  end
end
