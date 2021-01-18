class CreateVideosSearches < ActiveRecord::Migration[6.1]
  def change
    create_view :videos_searches, materialized: true
    add_index :videos_searches, :tsv_document , using: :gin
  end
end
