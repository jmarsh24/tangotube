class RemovePreviewHashFromActiveStorageBlobs < ActiveRecord::Migration[7.0]
  def change
    remove_column :active_storage_blobs, :preview_hash, :string
    remove_column :active_storage_blobs, :primary_color, :string
  end
end
