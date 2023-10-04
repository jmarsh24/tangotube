# frozen_string_literal: true

class AddPreviewHashToActiveStorageBlobs < ActiveRecord::Migration[7.0]
  def change
    add_column :active_storage_blobs, :preview_hash, :string
    add_column :active_storage_blobs, :primary_color, :string
  end
end
