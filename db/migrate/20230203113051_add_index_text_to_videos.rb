class AddTextToVideos < ActiveRecord::Migration[7.0]
  def change
    add_column :videos, :index, :text
  end
end
