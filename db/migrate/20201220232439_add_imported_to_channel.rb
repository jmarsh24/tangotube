class AddImportedToChannel < ActiveRecord::Migration[6.0]
  def change
    add_column :channels, :imported, :boolean, default: false
    add_column :channels, :imported_videos_count, :int
    add_column :channels, :total_videos_count, :int
  end
end
