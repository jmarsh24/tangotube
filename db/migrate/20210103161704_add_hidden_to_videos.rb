class AddHiddenToVideos < ActiveRecord::Migration[6.0]
  def change
    add_column :videos, :hidden, :boolean, default: false
  end
end
