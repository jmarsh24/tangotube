class AddHdToVideos < ActiveRecord::Migration[6.0]
  def change
    add_column :videos, :hd, :boolean, default: false
  end
end
