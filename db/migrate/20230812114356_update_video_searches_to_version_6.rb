class UpdateVideoSearchesToVersion6 < ActiveRecord::Migration[7.0]
  def change
    update_view :video_searches, version: 6, revert_to_version: 5, materialized: true
    add_index :video_searches, :video_description_vector, using: :gin
  end
end
