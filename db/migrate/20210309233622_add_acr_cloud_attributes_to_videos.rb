class AddAcrCloudAttributesToVideos < ActiveRecord::Migration[6.1]
  def change
    add_column :videos, :acr_cloud_artist_name, :string
    add_column :videos, :acr_cloud_artist_name_1, :string
    add_column :videos, :acr_cloud_album_name, :string
    add_column :videos, :acr_cloud_track_name, :string
  end
end
