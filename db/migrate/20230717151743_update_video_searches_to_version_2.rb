# frozen_string_literal: true

class UpdateVideoSearchesToVersion2 < ActiveRecord::Migration[7.0]
  def change
    update_view :video_searches, version: 2, revert_to_version: 1, materialized: true
    add_index :video_searches, :score
  end
end
