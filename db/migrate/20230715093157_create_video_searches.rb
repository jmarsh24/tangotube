class CreateVideoSearches < ActiveRecord::Migration[7.0]
  def change
    create_view :video_searches, materialized: true
    add_index :video_searches, :dancers_names, using: :gist, opclass: :gist_trgm_ops
    add_index :video_searches, :channels_title, using: :gist, opclass: :gist_trgm_ops
    add_index :video_searches, :songs_title, using: :gist, opclass: :gist_trgm_ops
    add_index :video_searches, :songs_artist, using: :gist, opclass: :gist_trgm_ops
    add_index :video_searches, :orchestras_name, using: :gist, opclass: :gist_trgm_ops
    add_index :video_searches, :events_city, using: :gist, opclass: :gist_trgm_ops
    add_index :video_searches, :events_title, using: :gist, opclass: :gist_trgm_ops
    add_index :video_searches, :events_country, using: :gist, opclass: :gist_trgm_ops
    add_index :video_searches, :videos_title, using: :gist, opclass: :gist_trgm_ops
    add_index :video_searches, :click_count
    add_index :video_searches, :upload_date
  end
end
