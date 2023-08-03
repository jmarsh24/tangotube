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

ActiveRecord::Schema[7.0].define(version: 2023_08_02_001003) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "btree_gin"
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
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", precision: nil, null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "channels", force: :cascade do |t|
    t.string "title"
    t.string "channel_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "thumbnail_url"
    t.boolean "reviewed", default: false
    t.boolean "active", default: true
    t.text "description"
    t.jsonb "metadata"
    t.datetime "metadata_updated_at"
    t.integer "videos_count", default: 0
    t.index ["active"], name: "index_channels_on_active"
    t.index ["channel_id"], name: "index_channels_on_channel_id", unique: true
    t.index ["title"], name: "index_channels_on_title_trigram", opclass: :gist_trgm_ops, using: :gist
    t.index ["videos_count"], name: "index_channels_on_videos_count"
  end

  create_table "clips", force: :cascade do |t|
    t.integer "start_seconds", null: false
    t.integer "end_seconds", null: false
    t.text "title"
    t.decimal "playback_rate", precision: 5, scale: 3, default: "1.0"
    t.bigint "user_id", null: false
    t.bigint "video_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
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
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["pid"], name: "index_deletion_requests_on_pid"
  end

  create_table "events", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
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

  create_table "likes", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "likeable_type", null: false
    t.bigint "likeable_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["likeable_type", "likeable_id"], name: "index_likes_on_likeable"
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
    t.index ["name"], name: "index_orchestras_on_name", unique: true
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
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
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
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
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
    t.index ["artist"], name: "index_songs_on_artist", opclass: :gin_trgm_ops, using: :gin
    t.index ["genre"], name: "index_songs_on_genre", opclass: :gin_trgm_ops, using: :gin
    t.index ["last_name_search"], name: "index_songs_on_last_name_search"
    t.index ["orchestra_id"], name: "index_songs_on_orchestra_id"
    t.index ["title"], name: "index_songs_on_title", opclass: :gin_trgm_ops, using: :gin
    t.index ["videos_count"], name: "index_songs_on_videos_count"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at", precision: nil
    t.datetime "remember_created_at", precision: nil
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
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
    t.index ["email"], name: "index_users_on_email"
    t.index ["patreon_id"], name: "index_users_on_patreon_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["uid", "provider"], name: "index_users_on_uid_and_provider", unique: true
  end

  create_table "videos", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.text "title"
    t.string "youtube_id"
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
    t.boolean "featured", default: false
    t.jsonb "metadata"
    t.text "tags", default: [], array: true
    t.date "upload_date"
    t.integer "upload_date_year"
    t.integer "youtube_view_count"
    t.integer "youtube_like_count"
    t.text "youtube_tags", default: [], array: true
    t.datetime "metadata_updated_at"
    t.string "normalized_title"
    t.index ["acr_response_code"], name: "index_videos_on_acr_response_code"
    t.index ["channel_id"], name: "index_videos_on_channel_id"
    t.index ["event_id"], name: "index_videos_on_event_id"
    t.index ["featured"], name: "index_videos_on_featured"
    t.index ["hd"], name: "index_videos_on_hd"
    t.index ["hidden"], name: "index_videos_on_hidden"
    t.index ["normalized_title"], name: "index_videos_on_normalized_title", opclass: :gin_trgm_ops, using: :gin
    t.index ["song_id"], name: "index_videos_on_song_id"
    t.index ["upload_date"], name: "index_videos_on_upload_date"
    t.index ["upload_date_year"], name: "index_videos_on_upload_date_year"
    t.index ["view_count"], name: "index_videos_on_view_count"
    t.index ["youtube_id"], name: "index_videos_on_youtube_id"
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
  add_foreign_key "couple_videos", "couples"
  add_foreign_key "couple_videos", "videos"
  add_foreign_key "couples", "dancers"
  add_foreign_key "couples", "dancers", column: "partner_id"
  add_foreign_key "dancers", "users"
  add_foreign_key "likes", "users"
  add_foreign_key "playlists", "users"
  add_foreign_key "playlists", "videos", column: "videos_id"
  add_foreign_key "recent_searches", "users"
  add_foreign_key "videos", "events"
  add_foreign_key "watches", "users"
  add_foreign_key "watches", "videos"

  create_view "video_scores", materialized: true, sql_definition: <<-SQL
      WITH likes_count AS (
           SELECT likes.likeable_id AS video_id,
              sum(exp(('-0.000001'::numeric * EXTRACT(epoch FROM (now() - (likes.created_at)::timestamp with time zone))))) AS decayed_likes
             FROM likes
            WHERE ((likes.likeable_type)::text = 'Video'::text)
            GROUP BY likes.likeable_id
          ), watches_count AS (
           SELECT watches.video_id,
              sum(exp(('-0.00001'::numeric * EXTRACT(epoch FROM (now() - (watches.created_at)::timestamp with time zone))))) AS decayed_watches
             FROM watches
            GROUP BY watches.video_id
          ), max_values AS (
           SELECT GREATEST(max(lc.decayed_likes), (1)::numeric) AS max_likes,
              GREATEST(max(wc.decayed_watches), (1)::numeric) AS max_watches
             FROM (likes_count lc
               CROSS JOIN watches_count wc)
          ), videos_with_score AS (
           SELECT videos.id AS video_id,
              ((EXTRACT(epoch FROM videos.upload_date) - ( SELECT min(EXTRACT(epoch FROM videos_1.upload_date)) AS min
                     FROM videos videos_1)) / (( SELECT max(EXTRACT(epoch FROM videos_1.upload_date)) AS max
                     FROM videos videos_1) - ( SELECT min(EXTRACT(epoch FROM videos_1.upload_date)) AS min
                     FROM videos videos_1))) AS normalized_upload_time,
              COALESCE((lc.decayed_likes / mv.max_likes), (0)::numeric) AS decayed_normalized_likes,
              COALESCE((wc.decayed_watches / mv.max_watches), (0)::numeric) AS decayed_normalized_watches,
                  CASE
                      WHEN (EXISTS ( SELECT 1
                         FROM dancer_videos
                        WHERE (dancer_videos.video_id = videos.id))) THEN 0.1
                      ELSE (0)::numeric
                  END AS dancer_score_adjustment
             FROM (((videos
               LEFT JOIN likes_count lc ON ((videos.id = lc.video_id)))
               LEFT JOIN watches_count wc ON ((videos.id = wc.video_id)))
               CROSS JOIN max_values mv)
          )
   SELECT videos_with_score.video_id,
      ((((((0.4 * videos_with_score.normalized_upload_time) + (0.1 * videos_with_score.decayed_normalized_likes)) + (0.1 * videos_with_score.decayed_normalized_watches)))::double precision + ((0.4)::double precision * random())) + (videos_with_score.dancer_score_adjustment)::double precision) AS score_1,
      ((((((0.4 * videos_with_score.normalized_upload_time) + (0.1 * videos_with_score.decayed_normalized_likes)) + (0.1 * videos_with_score.decayed_normalized_watches)))::double precision + ((0.4)::double precision * random())) + (videos_with_score.dancer_score_adjustment)::double precision) AS score_2,
      ((((((0.4 * videos_with_score.normalized_upload_time) + (0.1 * videos_with_score.decayed_normalized_likes)) + (0.1 * videos_with_score.decayed_normalized_watches)))::double precision + ((0.4)::double precision * random())) + (videos_with_score.dancer_score_adjustment)::double precision) AS score_3,
      ((((((0.4 * videos_with_score.normalized_upload_time) + (0.1 * videos_with_score.decayed_normalized_likes)) + (0.1 * videos_with_score.decayed_normalized_watches)))::double precision + ((0.4)::double precision * random())) + (videos_with_score.dancer_score_adjustment)::double precision) AS score_4,
      ((((((0.4 * videos_with_score.normalized_upload_time) + (0.1 * videos_with_score.decayed_normalized_likes)) + (0.1 * videos_with_score.decayed_normalized_watches)))::double precision + ((0.4)::double precision * random())) + (videos_with_score.dancer_score_adjustment)::double precision) AS score_5
     FROM videos_with_score;
  SQL
  add_index "video_scores", ["score_1"], name: "index_video_scores_on_score_1"
  add_index "video_scores", ["score_2"], name: "index_video_scores_on_score_2"
  add_index "video_scores", ["score_3"], name: "index_video_scores_on_score_3"
  add_index "video_scores", ["score_4"], name: "index_video_scores_on_score_4"
  add_index "video_scores", ["score_5"], name: "index_video_scores_on_score_5"
  add_index "video_scores", ["video_id"], name: "index_video_scores_on_video_id", unique: true

  create_view "video_searches", materialized: true, sql_definition: <<-SQL
      SELECT videos.id AS video_id,
      videos.youtube_id,
      videos.upload_date,
      lower(concat_ws(' '::text, string_agg(DISTINCT (dancers.name)::text, ' '::text))) AS dancer_names,
      lower(concat_ws(' '::text, string_agg(DISTINCT (channels.title)::text, ' '::text))) AS channel_title,
      lower(concat_ws(' '::text, string_agg(DISTINCT (songs.title)::text, ' '::text))) AS song_title,
      lower(concat_ws(' '::text, string_agg(DISTINCT (songs.artist)::text, ' '::text))) AS song_artist,
      lower(concat_ws(' '::text, string_agg(DISTINCT (orchestras.name)::text, ' '::text))) AS orchestra_name,
      lower(concat_ws(' '::text, string_agg(DISTINCT (events.city)::text, ' '::text))) AS event_city,
      lower(concat_ws(' '::text, string_agg(DISTINCT (events.title)::text, ' '::text))) AS event_title,
      lower(concat_ws(' '::text, string_agg(DISTINCT (events.country)::text, ' '::text))) AS event_country,
      lower(NORMALIZE(videos.title)) AS video_title,
      video_scores.score_1 AS score
     FROM (((((((((videos
       LEFT JOIN watches ON ((videos.id = watches.video_id)))
       LEFT JOIN likes ON (((videos.id = likes.likeable_id) AND ((likes.likeable_type)::text = 'Video'::text))))
       LEFT JOIN channels ON ((channels.id = videos.channel_id)))
       LEFT JOIN songs ON ((songs.id = videos.song_id)))
       LEFT JOIN events ON ((events.id = videos.event_id)))
       LEFT JOIN dancer_videos ON ((dancer_videos.video_id = videos.id)))
       LEFT JOIN dancers ON ((dancers.id = dancer_videos.dancer_id)))
       LEFT JOIN orchestras ON ((orchestras.id = songs.orchestra_id)))
       LEFT JOIN video_scores ON ((video_scores.video_id = videos.id)))
    GROUP BY videos.id, videos.youtube_id, video_scores.score_1
    ORDER BY video_scores.score_1 DESC;
  SQL
  add_index "video_searches", ["channel_title"], name: "index_video_searches_on_channel_title", opclass: :gist_trgm_ops, using: :gist
  add_index "video_searches", ["dancer_names"], name: "index_video_searches_on_dancer_names", opclass: :gist_trgm_ops, using: :gist
  add_index "video_searches", ["event_city"], name: "index_video_searches_on_event_city", opclass: :gist_trgm_ops, using: :gist
  add_index "video_searches", ["event_country"], name: "index_video_searches_on_event_country", opclass: :gist_trgm_ops, using: :gist
  add_index "video_searches", ["event_title"], name: "index_video_searches_on_event_title", opclass: :gist_trgm_ops, using: :gist
  add_index "video_searches", ["orchestra_name"], name: "index_video_searches_on_orchestra_name", opclass: :gist_trgm_ops, using: :gist
  add_index "video_searches", ["song_artist"], name: "index_video_searches_on_song_artist", opclass: :gist_trgm_ops, using: :gist
  add_index "video_searches", ["song_title"], name: "index_video_searches_on_song_title", opclass: :gist_trgm_ops, using: :gist
  add_index "video_searches", ["upload_date"], name: "index_video_searches_on_upload_date"
  add_index "video_searches", ["video_id"], name: "index_video_searches_on_video_id", unique: true
  add_index "video_searches", ["video_title"], name: "index_video_searches_on_video_title", opclass: :gist_trgm_ops, using: :gist

end
