class UpdateVideoSearchesToVersion7 < ActiveRecord::Migration[7.0]
  def change
    ActiveRecord::Base.connection.execute("SET statement_timeout TO 0")
    update_view :video_searches, version: 7, revert_to_version: 6, materialized: true
    add_index :video_searches, :dancer_names, using: :gist, opclass: :gist_trgm_ops
    add_index :video_searches, :channel_title, using: :gist, opclass: :gist_trgm_ops
    add_index :video_searches, :song_title, using: :gist, opclass: :gist_trgm_ops
    add_index :video_searches, :song_artist, using: :gist, opclass: :gist_trgm_ops
    add_index :video_searches, :orchestra_name, using: :gist, opclass: :gist_trgm_ops
    add_index :video_searches, :event_city, using: :gist, opclass: :gist_trgm_ops
    add_index :video_searches, :event_title, using: :gist, opclass: :gist_trgm_ops
    add_index :video_searches, :event_country, using: :gist, opclass: :gist_trgm_ops
    add_index :video_searches, :video_title, using: :gist, opclass: :gist_trgm_ops
    add_index :video_searches, :video_description_vector, using: :gin
    ActiveRecord::Base.connection.execute("SET statement_timeout TO 60000")
  end
end
