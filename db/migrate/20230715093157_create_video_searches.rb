# frozen_string_literal: true

class CreateVideoSearches < ActiveRecord::Migration[7.0]
  def up
    execute "SET statement_timeout = 600000"

    create_view :video_searches, materialized: true
    add_index :video_searches, :dancer_names, using: :gist, opclass: :gist_trgm_ops
    add_index :video_searches, :channel_title, using: :gist, opclass: :gist_trgm_ops
    add_index :video_searches, :song_title, using: :gist, opclass: :gist_trgm_ops
    add_index :video_searches, :song_artist, using: :gist, opclass: :gist_trgm_ops
    add_index :video_searches, :orchestra_name, using: :gist, opclass: :gist_trgm_ops
    add_index :video_searches, :event_city, using: :gist, opclass: :gist_trgm_ops
    add_index :video_searches, :event_title, using: :gist, opclass: :gist_trgm_ops
    add_index :video_searches, :event_country, using: :gist, opclass: :gist_trgm_ops
    add_index :video_searches, :video_title, using: :gist, opclass: :gist_trgm_ops
    add_index :video_searches, :click_count
    add_index :video_searches, :upload_date
    add_index :video_searches, :video_id, unique: true
  end

  def down
    remove_index :video_searches, :dancer_names
    remove_index :video_searches, :channel_title
    remove_index :video_searches, :song_title
    remove_index :video_searches, :song_artist
    remove_index :video_searches, :orchestra_name
    remove_index :video_searches, :event_city
    remove_index :video_searches, :event_title
    remove_index :video_searches, :event_country
    remove_index :video_searches, :video_title
    remove_index :video_searches, :click_count
    remove_index :video_searches, :upload_date
    remove_index :video_searches, :video_id
    execute "DROP MATERIALIZED VIEW IF EXISTS video_searches"
  end
end
