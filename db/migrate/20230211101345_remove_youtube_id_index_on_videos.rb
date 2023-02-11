# frozen_string_literal: true

class RemoveYoutubeIdIndexOnVideos < ActiveRecord::Migration[7.0]
  def change
    remove_index :videos, :youtube_id
  end
end
