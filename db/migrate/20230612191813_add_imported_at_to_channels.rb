class AddImportedAtToChannels < ActiveRecord::Migration[7.1]
  def change
    add_column :channels, :imported_at, :datetime
  end
end
