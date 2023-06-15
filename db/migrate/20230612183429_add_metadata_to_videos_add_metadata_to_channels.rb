# frozen_string_literal: true

class AddMetadataToVideosAddMetadataToChannels < ActiveRecord::Migration[7.1]
  def change
    add_column :channels, :metadata, :jsonb
  end
end
