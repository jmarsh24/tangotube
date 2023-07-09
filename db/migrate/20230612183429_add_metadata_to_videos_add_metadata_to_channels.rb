# frozen_string_literal: true

class AddMetadataToVideosAddMetadataToChannels < ActiveRecord::Migration[7.0]
  def change
    add_column :channels, :metadata, :jsonb
  end
end
