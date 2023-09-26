class AddPreviewHashToActiveStorageBlobs < ActiveRecord::Migration[7.0]
  def change
    add_column :active_storage_blobs, :preview_hash, :string
  end
end
