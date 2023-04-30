class AddMetadataToVideos < ActiveRecord::Migration[7.0]
  def change
    add_column :videos, :metadata, :jsonb
  end
end
