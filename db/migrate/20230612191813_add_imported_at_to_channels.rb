# frozen_string_literal: true

class AddImportedAtToChannels < ActiveRecord::Migration[7.1]
  def change
    add_column :channels, :metadata_updated_at, :datetime
    add_column :channels, :imported_at, :datetime
  end
end
