# frozen_string_literal: true

class AddNullConstraintToYouTubeIdOnVideos < ActiveRecord::Migration[7.0]
  def change
    change_column_null :videos, :youtube_id, false
  end
end
