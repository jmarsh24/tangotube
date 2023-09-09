# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2023_09_09_093500) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "fuzzystrmatch"
  enable_extension "pg_stat_statements"
  enable_extension "pg_trgm"
  enable_extension "pgcrypto"
  enable_extension "plpgsql"
  enable_extension "unaccent"

  create_enum :gender_new, [
    "male",
    "female",
  ], force: :cascade

  create_enum :role_new, [
    "neither",
    "leader",
    "follower",
    "both",
  ], force: :cascade

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", precision: nil, null: false
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "channels", force: :cascade do |t|
    t.string "title"
    t.string "youtube_slug", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "thumbnail_url"
    t.boolean "reviewed", default: false
    t.boolean "active", default: true
    t.text "description"
    t.jsonb "metadata"
    t.datetime "metadata_updated_at"
    t.integer "videos_count", default: 0
    t.index ["active"], name: "index_channels_on_active"
    t.index ["title"], name: "index_channels_on_title_trigram", opclass: :gist_trgm_ops, using: :gist
    t.index ["videos_count"], name: "index_channels_on_videos_count"
    t.index ["youtube_slug"], name: "index_channels_on_youtube_slug", unique: true
  end

  create_table "clips", force: :cascade do |t|
    t.integer "start_seconds", null: false
    t.integer "end_seconds", null: false
    t.text "title"
    t.decimal "playback_rate", precision: 5, scale: 3, default: "1.0"
    t.bigint "user_id", null: false
    t.bigint "video_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "giphy_id"
    t.index ["user_id"], name: "index_clips_on_user_id"
    t.index ["video_id"], name: "index_clips_on_video_id"
  end

  create_table "couple_videos", force: :cascade do |t|
    t.bigint "video_id", null: false
    t.bigint "couple_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["couple_id"], name: "index_couple_videos_on_couple_id"
    t.index ["video_id", "couple_id"], name: "index_couple_videos_on_video_id_and_couple_id", unique: true
    t.index ["video_id"], name: "index_couple_videos_on_video_id"
  end

  create_table "couples", force: :cascade do |t|
    t.bigint "dancer_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "partner_id"
    t.integer "videos_count", default: 0, null: false
    t.string "slug"
    t.string "unique_couple_id"
    t.index ["dancer_id", "partner_id"], name: "index_couples_on_dancer_id_and_partner_id", unique: true
    t.index ["dancer_id"], name: "index_couples_on_dancer_id"
    t.index ["partner_id"], name: "index_couples_on_partner_id"
    t.index ["unique_couple_id"], name: "index_couples_on_unique_couple_id"
  end

  create_table "dancer_videos", force: :cascade do |t|
    t.bigint "dancer_id"
    t.bigint "video_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.enum "role", enum_type: "role_new"
    t.index ["dancer_id", "video_id"], name: "index_dancer_videos_on_dancer_id_and_video_id", unique: true
    t.index ["dancer_id"], name: "index_dancer_videos_on_dancer_id"
    t.index ["video_id"], name: "index_dancer_videos_on_video_id"
  end

  create_table "dancers", force: :cascade do |t|
    t.string "name", null: false
    t.string "first_name"
    t.string "last_name"
    t.string "middle_name"
    t.string "nick_name", default: [], array: true
    t.bigint "user_id"
    t.text "bio"
    t.string "slug"
    t.boolean "reviewed", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "videos_count", default: 0, null: false
    t.enum "gender", enum_type: "gender_new"
    t.index ["name"], name: "index_dancers_on_name", opclass: :gist_trgm_ops, using: :gist
    t.index ["slug"], name: "index_dancers_on_slug"
    t.index ["user_id"], name: "index_dancers_on_user_id"
  end

  create_table "deletion_requests", force: :cascade do |t|
    t.string "provider"
    t.string "uid"
    t.string "pid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["pid"], name: "index_deletion_requests_on_pid"
    t.index ["uid", "provider"], name: "index_deletion_requests_on_uid_and_provider", unique: true
  end

  create_table "events", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "title", null: false
    t.string "city", null: false
    t.string "country", null: false
    t.string "category"
    t.date "start_date"
    t.date "end_date"
    t.boolean "active", default: true
    t.boolean "reviewed", default: false
    t.integer "videos_count", default: 0, null: false
    t.string "slug"
    t.index ["city"], name: "index_events_on_city_trigram", opclass: :gist_trgm_ops, using: :gist
    t.index ["country"], name: "index_events_on_country_trigram", opclass: :gist_trgm_ops, using: :gist
    t.index ["slug"], name: "index_events_on_slug", unique: true
    t.index ["title"], name: "index_events_on_title_trigram", opclass: :gist_trgm_ops, using: :gist
  end

  create_table "features", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "featureable_type", null: false
    t.bigint "featureable_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["featureable_type", "featureable_id"], name: "index_features_on_featureable"
    t.index ["featureable_type", "featureable_id"], name: "index_features_on_featureable_type_and_featureable_id"
    t.index ["user_id", "featureable_type", "featureable_id"], name: "index_features_on_user_and_featureable", unique: true
    t.index ["user_id"], name: "index_features_on_user_id"
  end

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string "slug", null: false
    t.integer "sluggable_id", null: false
    t.string "sluggable_type", limit: 50
    t.string "scope"
    t.datetime "created_at"
    t.index ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true
    t.index ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type"
    t.index ["sluggable_type", "sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_type_and_sluggable_id"
  end

  create_table "likes", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "likeable_type", null: false
    t.bigint "likeable_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["likeable_type", "likeable_id"], name: "index_likes_on_likeable"
    t.index ["user_id", "likeable_type", "likeable_id"], name: "index_likes_on_user_and_likeable", unique: true
    t.index ["user_id"], name: "index_likes_on_user_id"
  end

  create_table "orchestras", force: :cascade do |t|
    t.string "name", null: false
    t.text "bio"
    t.string "slug", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "videos_count", default: 0, null: false
    t.integer "songs_count", default: 0, null: false
    t.string "search_term"
    t.index ["name"], name: "index_orchestras_on_name", opclass: :gist_trgm_ops, using: :gist
    t.index ["slug"], name: "index_orchestras_on_slug"
  end

  create_table "patreon_events", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "event_type"
    t.jsonb "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "performance_videos", force: :cascade do |t|
    t.bigint "video_id"
    t.bigint "performance_id"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["performance_id", "video_id"], name: "index_performance_videos_on_performance_id_and_video_id"
    t.index ["performance_id"], name: "index_performance_videos_on_performance_id"
    t.index ["video_id"], name: "index_performance_videos_on_video_id"
  end

  create_table "performances", force: :cascade do |t|
    t.date "date"
    t.integer "videos_count", default: 0, null: false
    t.string "slug"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "playlists", force: :cascade do |t|
    t.string "slug"
    t.string "title"
    t.string "description"
    t.string "channel_title"
    t.string "channel_id"
    t.string "video_count"
    t.boolean "imported", default: false
    t.bigint "videos_id"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "reviewed", default: false
    t.index ["user_id"], name: "index_playlists_on_user_id"
    t.index ["videos_id"], name: "index_playlists_on_videos_id"
  end

  create_table "recent_searches", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "searchable_type"
    t.bigint "searchable_id"
    t.string "query"
    t.string "category"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["searchable_type", "searchable_id"], name: "index_recent_searches_on_searchable"
    t.index ["user_id"], name: "index_recent_searches_on_user_id"
  end

  create_table "songs", force: :cascade do |t|
    t.string "genre"
    t.string "title"
    t.string "artist"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "artist_2"
    t.string "composer"
    t.string "author"
    t.date "date"
    t.string "last_name_search"
    t.integer "occur_count", default: 0
    t.integer "popularity", default: 0
    t.boolean "active", default: true
    t.text "lyrics"
    t.integer "el_recodo_song_id"
    t.integer "videos_count", default: 0, null: false
    t.string "lyrics_en"
    t.string "slug"
    t.bigint "orchestra_id"
    t.string "display_title"
    t.string "spotify_track_id"
    t.index ["active"], name: "index_songs_on_active"
    t.index ["artist"], name: "index_songs_on_artist", opclass: :gist_trgm_ops, using: :gist
    t.index ["genre"], name: "index_songs_on_genre", opclass: :gist_trgm_ops, using: :gist
    t.index ["last_name_search"], name: "index_songs_on_last_name_search"
    t.index ["orchestra_id"], name: "index_songs_on_orchestra_id"
    t.index ["title"], name: "index_songs_on_title", opclass: :gist_trgm_ops, using: :gist
    t.index ["videos_count"], name: "index_songs_on_videos_count"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at", precision: nil
    t.datetime "remember_created_at", precision: nil
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.string "first_name"
    t.string "last_name"
    t.string "image"
    t.string "uid"
    t.string "provider"
    t.string "confirmation_token"
    t.datetime "confirmed_at", precision: nil
    t.datetime "confirmation_sent_at", precision: nil
    t.string "unconfirmed_email"
    t.integer "role"
    t.boolean "supporter", default: false
    t.string "patreon_id"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["patreon_id"], name: "index_users_on_patreon_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["uid", "provider"], name: "index_users_on_uid_and_provider", unique: true
  end

  create_table "videos", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "title"
    t.string "youtube_id", null: false
    t.string "description"
    t.integer "duration"
    t.integer "view_count"
    t.bigint "song_id"
    t.integer "acr_response_code"
    t.bigint "channel_id"
    t.boolean "hidden", default: false
    t.boolean "hd", default: false
    t.integer "like_count", default: 0
    t.bigint "event_id"
    t.jsonb "metadata"
    t.text "tags", default: [], array: true
    t.date "upload_date"
    t.integer "upload_date_year"
    t.integer "youtube_view_count"
    t.integer "youtube_like_count"
    t.text "youtube_tags", default: [], array: true
    t.datetime "metadata_updated_at"
    t.string "normalized_title"
    t.string "slug"
    t.integer "likes_count", default: 0
    t.integer "watches_count", default: 0
    t.integer "features_count", default: 0
    t.index ["acr_response_code"], name: "index_videos_on_acr_response_code"
    t.index ["channel_id"], name: "index_videos_on_channel_id"
    t.index ["event_id"], name: "index_videos_on_event_id"
    t.index ["hd"], name: "index_videos_on_hd"
    t.index ["hidden"], name: "index_videos_on_hidden"
    t.index ["slug"], name: "index_videos_on_slug", unique: true
    t.index ["song_id"], name: "index_videos_on_song_id"
    t.index ["upload_date"], name: "index_videos_on_upload_date"
    t.index ["upload_date_year"], name: "index_videos_on_upload_date_year"
    t.index ["view_count"], name: "index_videos_on_view_count"
    t.index ["youtube_id"], name: "index_videos_on_youtube_id", unique: true
  end

  create_table "watches", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "video_id", null: false
    t.datetime "watched_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_watches_on_user_id"
    t.index ["video_id"], name: "index_watches_on_video_id"
  end

  create_table "youtube_events", force: :cascade do |t|
    t.jsonb "data"
    t.integer "status", default: 0
    t.string "processing_errors"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "clips", "users"
  add_foreign_key "clips", "videos"
  add_foreign_key "couple_videos", "couples", on_delete: :cascade
  add_foreign_key "couple_videos", "videos"
  add_foreign_key "couples", "dancers", column: "partner_id", on_delete: :cascade
  add_foreign_key "couples", "dancers", on_delete: :cascade
  add_foreign_key "dancers", "users"
  add_foreign_key "features", "users"
  add_foreign_key "likes", "users"
  add_foreign_key "playlists", "users"
  add_foreign_key "playlists", "videos", column: "videos_id"
  add_foreign_key "recent_searches", "users"
  add_foreign_key "videos", "events"
  add_foreign_key "watches", "users"
  add_foreign_key "watches", "videos"

  create_view "video_searches", materialized: true, sql_definition: <<-SQL
      SELECT videos.id AS video_id,
      videos.youtube_id,
      videos.upload_date,
      videos.description AS video_description,
      to_tsvector('english'::regconfig, (videos.description)::text) AS video_description_vector,
      TRIM(BOTH FROM lower(heroku_ext.unaccent(regexp_replace(concat_ws(' '::text, string_agg(DISTINCT (dancers.name)::text, ' '::text)), '[^\\w\\s]'::text, ' '::text, 'g'::text)))) AS dancer_names,
      TRIM(BOTH FROM lower(heroku_ext.unaccent(regexp_replace(concat_ws(' '::text, string_agg(DISTINCT (channels.title)::text, ' '::text)), '[^\\w\\s]'::text, ' '::text, 'g'::text)))) AS channel_title,
      TRIM(BOTH FROM lower(heroku_ext.unaccent(regexp_replace(concat_ws(' '::text, string_agg(DISTINCT (songs.title)::text, ' '::text)), '[^\\w\\s]'::text, ' '::text, 'g'::text)))) AS song_title,
      TRIM(BOTH FROM lower(heroku_ext.unaccent(regexp_replace(concat_ws(' '::text, string_agg(DISTINCT (songs.artist)::text, ' '::text)), '[^\\w\\s]'::text, ' '::text, 'g'::text)))) AS song_artist,
      TRIM(BOTH FROM lower(heroku_ext.unaccent(regexp_replace(concat_ws(' '::text, string_agg(DISTINCT (orchestras.name)::text, ' '::text)), '[^\\w\\s]'::text, ' '::text, 'g'::text)))) AS orchestra_name,
      TRIM(BOTH FROM lower(heroku_ext.unaccent(regexp_replace(concat_ws(' '::text, string_agg(DISTINCT (events.city)::text, ' '::text)), '[^\\w\\s]'::text, ' '::text, 'g'::text)))) AS event_city,
      TRIM(BOTH FROM lower(heroku_ext.unaccent(regexp_replace(concat_ws(' '::text, string_agg(DISTINCT (events.title)::text, ' '::text)), '[^\\w\\s]'::text, ' '::text, 'g'::text)))) AS event_title,
      TRIM(BOTH FROM lower(heroku_ext.unaccent(regexp_replace(concat_ws(' '::text, string_agg(DISTINCT (events.country)::text, ' '::text)), '[^\\w\\s]'::text, ' '::text, 'g'::text)))) AS event_country,
      TRIM(BOTH FROM lower(heroku_ext.unaccent(regexp_replace(NORMALIZE(videos.title), '[^\\w\\s]'::text, ' '::text, 'g'::text)))) AS video_title
     FROM ((((((videos
       LEFT JOIN channels ON ((channels.id = videos.channel_id)))
       LEFT JOIN songs ON ((songs.id = videos.song_id)))
       LEFT JOIN events ON ((events.id = videos.event_id)))
       LEFT JOIN dancer_videos ON ((dancer_videos.video_id = videos.id)))
       LEFT JOIN dancers ON ((dancers.id = dancer_videos.dancer_id)))
       LEFT JOIN orchestras ON ((orchestras.id = songs.orchestra_id)))
    GROUP BY videos.id, videos.youtube_id
    ORDER BY videos.id DESC;
  SQL
  add_index "video_searches", ["channel_title"], name: "index_video_searches_on_channel_title", opclass: :gist_trgm_ops, using: :gist
  add_index "video_searches", ["dancer_names"], name: "index_video_searches_on_dancer_names", opclass: :gist_trgm_ops, using: :gist
  add_index "video_searches", ["event_city"], name: "index_video_searches_on_event_city", opclass: :gist_trgm_ops, using: :gist
  add_index "video_searches", ["upload_date"], name: "index_video_searches_on_upload_date"
  add_index "video_searches", ["video_description_vector"], name: "index_video_searches_on_video_description_vector", using: :gin
  add_index "video_searches", ["video_id"], name: "index_video_searches_on_video_id", unique: true

  create_view "video_scores", materialized: true, sql_definition: <<-SQL
      WITH combined_counts AS (
           SELECT v_1.id AS video_id,
              COALESCE(count(DISTINCT likes.likeable_id), (0)::bigint) AS total_likes,
              COALESCE(count(DISTINCT watches.user_id), (0)::bigint) AS total_watches,
              COALESCE(count(DISTINCT features.featureable_id), (0)::bigint) AS total_features,
                  CASE
                      WHEN (EXISTS ( SELECT 1
                         FROM dancer_videos dv
                        WHERE (dv.video_id = v_1.id))) THEN 0.1
                      ELSE (0)::numeric
                  END AS dancer_score_adjustment
             FROM (((videos v_1
               LEFT JOIN likes ON (((v_1.id = likes.likeable_id) AND ((likes.likeable_type)::text = 'Video'::text) AND (likes.created_at > (now() - 'P6D'::interval)))))
               LEFT JOIN watches ON (((v_1.id = watches.video_id) AND (watches.created_at > (now() - 'P6D'::interval)))))
               LEFT JOIN features ON (((v_1.id = features.featureable_id) AND ((features.featureable_type)::text = 'Video'::text))))
            GROUP BY v_1.id
          ), upload_date_range AS (
           SELECT min(EXTRACT(epoch FROM (videos.upload_date)::timestamp without time zone)) AS min_upload_epoch,
              max(EXTRACT(epoch FROM (videos.upload_date)::timestamp without time zone)) AS max_upload_epoch
             FROM videos
          ), norm_counts AS (
           SELECT combined_counts.video_id,
              ((combined_counts.total_likes)::double precision / (NULLIF(max(combined_counts.total_likes) OVER (), 0))::double precision) AS normalized_likes,
              ((combined_counts.total_watches)::double precision / (NULLIF(max(combined_counts.total_watches) OVER (), 0))::double precision) AS normalized_watches,
              ((combined_counts.total_features)::double precision / (NULLIF(max(combined_counts.total_features) OVER (), 0))::double precision) AS normalized_features,
              combined_counts.dancer_score_adjustment,
              combined_counts.total_likes,
              combined_counts.total_watches,
              combined_counts.total_features
             FROM combined_counts
          )
   SELECT cc.video_id,
      v.title AS video_title,
      ((((((((0.5 * (EXTRACT(epoch FROM v.upload_date) - udr.min_upload_epoch)) / (udr.max_upload_epoch - udr.min_upload_epoch)))::double precision + ((0.2)::double precision * cc.normalized_likes)) + ((0.15)::double precision * cc.normalized_watches)) + ((0.05)::double precision * cc.normalized_features)) + ((0.05)::double precision * random())) + (cc.dancer_score_adjustment)::double precision) AS score_1,
      ((((((((0.15 * (EXTRACT(epoch FROM v.upload_date) - udr.min_upload_epoch)) / (udr.max_upload_epoch - udr.min_upload_epoch)))::double precision + ((0.35)::double precision * cc.normalized_likes)) + ((0.35)::double precision * cc.normalized_watches)) + ((0.1)::double precision * cc.normalized_features)) + ((0.025)::double precision * random())) + (cc.dancer_score_adjustment)::double precision) AS score_2,
      ((((((((0.1 * (EXTRACT(epoch FROM v.upload_date) - udr.min_upload_epoch)) / (udr.max_upload_epoch - udr.min_upload_epoch)))::double precision + ((0.25)::double precision * cc.normalized_likes)) + ((0.25)::double precision * cc.normalized_watches)) + ((0.15)::double precision * cc.normalized_features)) + ((0.2)::double precision * random())) + (cc.dancer_score_adjustment)::double precision) AS score_3,
      ((((((((0.1 * (EXTRACT(epoch FROM v.upload_date) - udr.min_upload_epoch)) / (udr.max_upload_epoch - udr.min_upload_epoch)))::double precision + ((0.2)::double precision * cc.normalized_likes)) + ((0.2)::double precision * cc.normalized_watches)) + ((0.1)::double precision * cc.normalized_features)) + ((0.1)::double precision * random())) + ((0.3 * cc.dancer_score_adjustment))::double precision) AS score_4,
      ((((((((0.2 * (EXTRACT(epoch FROM v.upload_date) - udr.min_upload_epoch)) / (udr.max_upload_epoch - udr.min_upload_epoch)))::double precision + ((0.3)::double precision * cc.normalized_likes)) + ((0.3)::double precision * cc.normalized_watches)) + ((0.1)::double precision * cc.normalized_features)) + ((0.05)::double precision * random())) + ((0.05 * cc.dancer_score_adjustment))::double precision) AS score_5,
      (0.5 * ((1)::numeric - ((EXTRACT(epoch FROM (v.upload_date)::timestamp without time zone) - udr.min_upload_epoch) / (udr.max_upload_epoch - udr.min_upload_epoch)))) AS score_6
     FROM ((norm_counts cc
       JOIN videos v ON ((cc.video_id = v.id)))
       CROSS JOIN upload_date_range udr);
  SQL
  add_index "video_scores", ["score_1"], name: "index_video_scores_on_score_1"
  add_index "video_scores", ["score_2"], name: "index_video_scores_on_score_2"
  add_index "video_scores", ["score_3"], name: "index_video_scores_on_score_3"
  add_index "video_scores", ["score_4"], name: "index_video_scores_on_score_4"
  add_index "video_scores", ["score_5"], name: "index_video_scores_on_score_5"
  add_index "video_scores", ["score_6"], name: "index_video_scores_on_score_6"
  add_index "video_scores", ["video_id"], name: "index_video_scores_on_video_id", unique: true

end
