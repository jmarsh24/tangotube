# frozen_string_literal: true

class AddMetadataUpdatedAtToVideos < ActiveRecord::Migration[7.1]
  def change
    add_column :videos, :metadata_updated_at, :datetime
  end
end
