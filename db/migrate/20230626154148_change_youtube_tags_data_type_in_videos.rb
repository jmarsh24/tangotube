# frozen_string_literal: true

class ChangeYoutubeTagsDataTypeInVideos < ActiveRecord::Migration[7.0]
  def change
    change_column :videos, :youtube_tags, :text, array: true, default: []
  end
end
