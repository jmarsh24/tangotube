# frozen_string_literal: true

class UpdateVideoSearchesToVersion3 < ActiveRecord::Migration[7.0]
  def change
    update_view :video_searches, version: 3, revert_to_version: 2, materialized: true
  end
end
