class ChangeDefaultValueOfChannels < ActiveRecord::Migration[6.0]
  def change
    change_column :channels, :imported, :boolean, default: false
    change_column :channels, :imported_videos_count, :int, default: 0
    change_column :channels, :total_videos_count, :int, default: 0
    change_column :channels, :yt_api_pull_count, :int, default: 0
  end
end
