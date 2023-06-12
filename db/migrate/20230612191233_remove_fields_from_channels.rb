class RemoveFieldsFromChannels < ActiveRecord::Migration[7.1]
  def change
    remove_column :channels, :imported, :boolean
    remove_column :channels, :imported_videos_count, :integer
    remove_column :channels, :total_videos_count, :integer
    remove_column :channels, :yt_api_pull_count, :integer
    remove_column :channels, :videos_count, :integer
  end
end
