class AddFeaturedToVideos < ActiveRecord::Migration[7.0]
  def change
    add_column :videos, :featured, :boolean, default: :false, index: true
  end
end
