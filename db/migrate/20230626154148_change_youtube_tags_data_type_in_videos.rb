class ChangeYoutubeTagsDataTypeInVideos < ActiveRecord::Migration[7.1]
  def change
    change_column :videos, :youtube_tags, :text, array: true, default: []
  end
end
