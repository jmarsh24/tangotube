class CreateMatVideos < ActiveRecord::Migration[6.1]
  def change
    create_view :mat_videos, materialized: true
    add_index :mat_videos, :tsv_document , using: :gin
  end
end
