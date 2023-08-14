class RenameChannelIdToYoutubeSlugInVideos < ActiveRecord::Migration[7.0]
  def change
    rename_column :channels, :channel_id, :youtube_slug
  end
end
