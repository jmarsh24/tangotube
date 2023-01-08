# frozen_string_literal: true

class CreateVideoSearches < ActiveRecord::Migration[7.0]
  def change
    create_view :video_searches, materialized: true
    add_index :video_searches, :tsv_content_tsearch, using: :gin
    add_index :video_searches, :video_id, unique: true
  end
end
