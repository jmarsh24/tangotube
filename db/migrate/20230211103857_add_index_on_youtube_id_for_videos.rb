# frozen_string_literal: true

class AddIndexOnYoutubeIdForVideos < ActiveRecord::Migration[7.0]
  def change
    add_index :videos, :youtube_id, unique: true
  end
end
