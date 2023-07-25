# frozen_string_literal: true

class UpdateVideoScoresToVersion5 < ActiveRecord::Migration[7.0]
  def change
    update_view :video_scores, version: 5, revert_to_version: 4, materialized: true
  end
end
