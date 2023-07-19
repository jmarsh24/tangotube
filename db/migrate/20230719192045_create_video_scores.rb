# frozen_string_literal: true

class CreateVideoScores < ActiveRecord::Migration[7.0]
  def change
    create_view :video_scores, materialized: true
    add_index :video_scores, :score_1
    add_index :video_scores, :score_2
    add_index :video_scores, :score_3
    add_index :video_scores, :score_4
    add_index :video_scores, :score_5
    add_index :video_scores, :video_id, unique: true
  end
end
