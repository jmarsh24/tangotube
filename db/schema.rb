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

ActiveRecord::Schema[7.0].define(version: 2022_08_22_193925) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "fuzzystrmatch"
  enable_extension "pg_trgm"
  enable_extension "plpgsql"
  enable_extension "unaccent"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
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
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "ahoy_events", id: false, force: :cascade do |t|
    t.bigserial "id", null: false
    t.bigint "visit_id"
    t.bigint "user_id"
    t.string "name"
    t.jsonb "properties"
    t.datetime "time", precision: nil
    t.index ["name", "time"], name: "index_ahoy_events_on_name_and_time"
    t.index ["properties"], name: "index_ahoy_events_on_properties", opclass: :jsonb_path_ops, using: :gin
    t.index ["user_id"], name: "index_ahoy_events_on_user_id"
    t.index ["visit_id"], name: "index_ahoy_events_on_visit_id"
  end

  create_table "ahoy_visits", id: false, force: :cascade do |t|
    t.bigserial "id", null: false
    t.string "visit_token"
    t.string "visitor_token"
    t.bigint "user_id"
    t.string "ip"
    t.text "user_agent"
    t.text "referrer"
    t.string "referring_domain"
    t.text "landing_page"
    t.string "browser"
    t.string "os"
    t.string "device_type"
    t.string "country"
    t.string "region"
    t.string "city"
    t.float "latitude"
    t.float "longitude"
    t.string "utm_source"
    t.string "utm_medium"
    t.string "utm_term"
    t.string "utm_content"
    t.string "utm_campaign"
    t.string "app_version"
    t.string "os_version"
    t.string "platform"
    t.datetime "started_at", precision: nil
    t.index ["user_id"], name: "index_ahoy_visits_on_user_id"
    t.index ["visit_token"], name: "index_ahoy_visits_on_visit_token", unique: true
  end

  create_table "channels", force: :cascade do |t|
    t.string "title"
    t.string "channel_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "thumbnail_url"
    t.boolean "imported", default: false
    t.integer "imported_videos_count", default: 0
    t.integer "total_videos_count", default: 0
    t.integer "yt_api_pull_count", default: 0
    t.boolean "reviewed", default: false
    t.integer "videos_count", default: 0, null: false
    t.boolean "active", default: true
    t.index ["channel_id"], name: "index_channels_on_channel_id", unique: true
    t.index ["title"], name: "index_channels_on_title"
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

  create_table "comments", force: :cascade do |t|
    t.bigint "user_id"
    t.string "commentable_type"
    t.bigint "commentable_id"
    t.integer "parent_id"
    t.text "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["commentable_type", "commentable_id"], name: "index_comments_on_commentable"
    t.index ["user_id"], name: "index_comments_on_user_id"
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
    t.integer "role", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["dancer_id", "video_id"], name: "index_dancer_videos_on_dancer_id_and_video_id", unique: true
    t.index ["dancer_id"], name: "index_dancer_videos_on_dancer_id"
    t.index ["video_id"], name: "index_dancer_videos_on_video_id"
  end

  create_table "dancers", force: :cascade do |t|
    t.string "name", null: false
    t.string "first_name"
    t.string "last_name"
    t.string "middle_name"
    t.string "nick_name"
    t.bigint "user_id"
    t.text "bio"
    t.string "slug"
    t.boolean "reviewed", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "videos_count", default: 0, null: false
    t.integer "gender"
    t.index ["user_id"], name: "index_dancers_on_user_id"
  end

  create_table "deletion_requests", force: :cascade do |t|
    t.string "provider"
    t.string "uid"
    t.string "pid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["pid"], name: "index_deletion_requests_on_pid"
  end

  create_table "events", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "title"
    t.string "city"
    t.string "country"
    t.string "category"
    t.date "start_date"
    t.date "end_date"
    t.boolean "active", default: true
    t.boolean "reviewed", default: false
    t.integer "videos_count", default: 0, null: false
    t.string "slug"
    t.index ["slug"], name: "index_events_on_slug", unique: true
    t.index ["title"], name: "index_events_on_title"
  end

  create_table "followers", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "reviewed"
    t.string "nickname"
    t.string "first_name"
    t.string "last_name"
    t.integer "videos_count", default: 0, null: false
    t.string "normalized_name"
    t.index ["name"], name: "index_followers_on_name"
  end

  create_table "leaders", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "reviewed"
    t.string "nickname"
    t.string "first_name"
    t.string "last_name"
    t.integer "videos_count", default: 0, null: false
    t.string "normalized_name"
    t.index ["name"], name: "index_leaders_on_name"
  end

  create_table "orchestras", force: :cascade do |t|
    t.string "name", null: false
    t.text "bio"
    t.string "slug", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "videos_count", default: 0, null: false
    t.integer "songs_count", default: 0, null: false
    t.index ["name"], name: "index_orchestras_on_name", unique: true
  end

  create_table "pay_charges", force: :cascade do |t|
    t.integer "customer_id", null: false
    t.integer "subscription_id"
    t.string "processor_id", null: false
    t.integer "amount", null: false
    t.string "currency"
    t.integer "application_fee_amount"
    t.integer "amount_refunded"
    t.jsonb "metadata"
    t.jsonb "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["customer_id", "processor_id"], name: "index_pay_charges_on_customer_id_and_processor_id", unique: true
    t.index ["subscription_id"], name: "index_pay_charges_on_subscription_id"
  end

  create_table "pay_customers", force: :cascade do |t|
    t.string "owner_type"
    t.integer "owner_id"
    t.string "processor", null: false
    t.string "processor_id"
    t.boolean "default"
    t.jsonb "data"
    t.datetime "deleted_at", precision: nil
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["owner_type", "owner_id", "deleted_at", "default"], name: "pay_customer_owner_index"
    t.index ["processor", "processor_id"], name: "index_pay_customers_on_processor_and_processor_id", unique: true
  end

  create_table "pay_merchants", force: :cascade do |t|
    t.string "owner_type"
    t.integer "owner_id"
    t.string "processor", null: false
    t.string "processor_id"
    t.boolean "default"
    t.jsonb "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["owner_type", "owner_id", "processor"], name: "index_pay_merchants_on_owner_type_and_owner_id_and_processor"
  end

  create_table "pay_payment_methods", force: :cascade do |t|
    t.integer "customer_id", null: false
    t.string "processor_id", null: false
    t.boolean "default"
    t.string "type"
    t.jsonb "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["customer_id", "processor_id"], name: "index_pay_payment_methods_on_customer_id_and_processor_id", unique: true
  end

  create_table "pay_subscriptions", force: :cascade do |t|
    t.integer "customer_id", null: false
    t.string "name", null: false
    t.string "processor_id", null: false
    t.string "processor_plan", null: false
    t.integer "quantity", default: 1, null: false
    t.string "status", null: false
    t.datetime "trial_ends_at", precision: nil
    t.datetime "ends_at", precision: nil
    t.decimal "application_fee_percent", precision: 8, scale: 2
    t.jsonb "metadata"
    t.jsonb "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["customer_id", "processor_id"], name: "index_pay_subscriptions_on_customer_id_and_processor_id", unique: true
  end

  create_table "pay_webhooks", force: :cascade do |t|
    t.string "processor"
    t.string "event_type"
    t.jsonb "event"
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
    t.integer "videos_count"
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
    t.index ["artist"], name: "index_songs_on_artist"
    t.index ["genre"], name: "index_songs_on_genre"
    t.index ["last_name_search"], name: "index_songs_on_last_name_search"
    t.index ["orchestra_id"], name: "index_songs_on_orchestra_id"
    t.index ["title"], name: "index_songs_on_title"
  end

  create_table "taggings", force: :cascade do |t|
    t.integer "tag_id"
    t.string "taggable_type"
    t.integer "taggable_id"
    t.string "tagger_type"
    t.integer "tagger_id"
    t.string "context", limit: 128
    t.datetime "created_at", precision: nil
    t.string "tenant", limit: 128
    t.index ["context"], name: "index_taggings_on_context"
    t.index ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true
    t.index ["tag_id"], name: "index_taggings_on_tag_id"
    t.index ["taggable_id", "taggable_type", "context"], name: "taggings_taggable_context_idx"
    t.index ["taggable_id", "taggable_type", "tagger_id", "context"], name: "taggings_idy"
    t.index ["taggable_id"], name: "index_taggings_on_taggable_id"
    t.index ["taggable_type", "taggable_id"], name: "index_taggings_on_taggable_type_and_taggable_id"
    t.index ["taggable_type"], name: "index_taggings_on_taggable_type"
    t.index ["tagger_id", "tagger_type"], name: "index_taggings_on_tagger_id_and_tagger_type"
    t.index ["tagger_id"], name: "index_taggings_on_tagger_id"
    t.index ["tagger_type", "tagger_id"], name: "index_taggings_on_tagger_type_and_tagger_id"
    t.index ["tenant"], name: "index_taggings_on_tenant"
  end

  create_table "tags", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "taggings_count", default: 0
    t.index ["name"], name: "index_tags_on_name", unique: true
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
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "videos", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "title"
    t.string "youtube_id"
    t.bigint "leader_id"
    t.bigint "follower_id"
    t.string "description"
    t.integer "duration"
    t.datetime "upload_date", precision: nil
    t.integer "view_count"
    t.string "tags"
    t.bigint "song_id"
    t.string "youtube_song"
    t.string "youtube_artist"
    t.string "acrid"
    t.string "spotify_album_id"
    t.string "spotify_album_name"
    t.string "spotify_artist_id"
    t.string "spotify_artist_id_2"
    t.string "spotify_artist_name"
    t.string "spotify_artist_name_2"
    t.string "spotify_track_id"
    t.string "spotify_track_name"
    t.string "youtube_song_id"
    t.string "isrc"
    t.integer "acr_response_code"
    t.bigint "channel_id"
    t.boolean "scanned_song", default: false
    t.boolean "hidden", default: false
    t.boolean "hd", default: false
    t.integer "popularity", default: 0
    t.integer "like_count", default: 0
    t.integer "dislike_count", default: 0
    t.integer "favorite_count", default: 0
    t.integer "comment_count", default: 0
    t.bigint "event_id"
    t.boolean "scanned_youtube_music", default: false
    t.integer "click_count", default: 0
    t.string "acr_cloud_artist_name"
    t.string "acr_cloud_artist_name_1"
    t.string "acr_cloud_album_name"
    t.string "acr_cloud_track_name"
    t.datetime "performance_date", precision: nil
    t.string "spotify_artist_id_1"
    t.string "spotify_artist_name_1"
    t.integer "performance_number"
    t.integer "performance_total_number"
    t.integer "cached_scoped_like_votes_total", default: 0
    t.integer "cached_scoped_like_votes_score", default: 0
    t.integer "cached_scoped_like_votes_up", default: 0
    t.integer "cached_scoped_like_votes_down", default: 0
    t.integer "cached_weighted_like_score", default: 0
    t.integer "cached_weighted_like_total", default: 0
    t.float "cached_weighted_like_average", default: 0.0
    t.boolean "featured", default: false
    t.index ["acr_cloud_artist_name"], name: "index_videos_on_acr_cloud_artist_name"
    t.index ["acr_cloud_track_name"], name: "index_videos_on_acr_cloud_track_name"
    t.index ["channel_id"], name: "index_videos_on_channel_id"
    t.index ["event_id"], name: "index_videos_on_event_id"
    t.index ["featured"], name: "index_videos_on_featured"
    t.index ["follower_id"], name: "index_videos_on_follower_id"
    t.index ["hd"], name: "index_videos_on_hd"
    t.index ["hidden"], name: "index_videos_on_hidden"
    t.index ["leader_id"], name: "index_videos_on_leader_id"
    t.index ["performance_date"], name: "index_videos_on_performance_date"
    t.index ["popularity"], name: "index_videos_on_popularity"
    t.index ["song_id"], name: "index_videos_on_song_id"
    t.index ["spotify_artist_name"], name: "index_videos_on_spotify_artist_name"
    t.index ["spotify_track_name"], name: "index_videos_on_spotify_track_name"
    t.index ["tags"], name: "index_videos_on_tags"
    t.index ["upload_date"], name: "index_videos_on_upload_date"
    t.index ["view_count"], name: "index_videos_on_view_count"
    t.index ["youtube_artist"], name: "index_videos_on_youtube_artist"
    t.index ["youtube_id"], name: "index_videos_on_youtube_id"
    t.index ["youtube_song"], name: "index_videos_on_youtube_song"
  end

  create_table "votes", force: :cascade do |t|
    t.string "votable_type"
    t.bigint "votable_id"
    t.string "voter_type"
    t.bigint "voter_id"
    t.boolean "vote_flag"
    t.string "vote_scope"
    t.integer "vote_weight"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["votable_id", "votable_type", "vote_scope"], name: "index_votes_on_votable_id_and_votable_type_and_vote_scope"
    t.index ["votable_type", "votable_id"], name: "index_votes_on_votable"
    t.index ["voter_id", "voter_type", "vote_scope"], name: "index_votes_on_voter_id_and_voter_type_and_vote_scope"
    t.index ["voter_type", "voter_id"], name: "index_votes_on_voter"
  end

  create_table "youtube_events", force: :cascade do |t|
    t.jsonb "data"
    t.integer "status", default: 0
    t.string "processing_errors"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "yt_comments", force: :cascade do |t|
    t.bigint "video_id", null: false
    t.text "body", null: false
    t.text "user_name", null: false
    t.integer "like_count", default: 0, null: false
    t.date "date", null: false
    t.string "channel_id", null: false
    t.string "profile_image_url", null: false
    t.string "youtube_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["video_id"], name: "index_yt_comments_on_video_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "clips", "users"
  add_foreign_key "clips", "videos"
  add_foreign_key "comments", "users"
  add_foreign_key "couple_videos", "couples"
  add_foreign_key "couple_videos", "videos"
  add_foreign_key "couples", "dancers"
  add_foreign_key "couples", "dancers", column: "partner_id"
  add_foreign_key "dancers", "users"
  add_foreign_key "pay_charges", "pay_customers", column: "customer_id"
  add_foreign_key "pay_charges", "pay_subscriptions", column: "subscription_id"
  add_foreign_key "pay_payment_methods", "pay_customers", column: "customer_id"
  add_foreign_key "pay_subscriptions", "pay_customers", column: "customer_id"
  add_foreign_key "playlists", "users"
  add_foreign_key "playlists", "videos", column: "videos_id"
  add_foreign_key "taggings", "tags"
  add_foreign_key "videos", "events"
  add_foreign_key "yt_comments", "videos"

  create_view "video_searches", materialized: true, sql_definition: <<-SQL
      SELECT videos.id AS video_id,
      (((((((((((((((((((((((setweight(to_tsvector('english'::regconfig, (COALESCE(channels.title, ''::character varying))::text), 'C'::"char") || setweight(to_tsvector('english'::regconfig, (COALESCE(channels.channel_id, ''::character varying))::text), 'C'::"char")) || setweight(to_tsvector('english'::regconfig, COALESCE(string_agg((dancers.name)::text, ' ; '::text), ''::text)), 'C'::"char")) || setweight(to_tsvector('english'::regconfig, COALESCE(string_agg((dancers.nick_name)::text, ' ; '::text), ''::text)), 'C'::"char")) || setweight(to_tsvector('english'::regconfig, (COALESCE(leaders.name, ''::character varying))::text), 'C'::"char")) || setweight(to_tsvector('english'::regconfig, (COALESCE(leaders.nickname, ''::character varying))::text), 'C'::"char")) || setweight(to_tsvector('english'::regconfig, (COALESCE(followers.name, ''::character varying))::text), 'C'::"char")) || setweight(to_tsvector('english'::regconfig, (COALESCE(followers.nickname, ''::character varying))::text), 'C'::"char")) || setweight(to_tsvector('english'::regconfig, (COALESCE(events.city, ''::character varying))::text), 'C'::"char")) || setweight(to_tsvector('english'::regconfig, (COALESCE(events.title, ''::character varying))::text), 'C'::"char")) || setweight(to_tsvector('english'::regconfig, (COALESCE(events.country, ''::character varying))::text), 'C'::"char")) || setweight(to_tsvector('english'::regconfig, (COALESCE(songs.genre, ''::character varying))::text), 'C'::"char")) || setweight(to_tsvector('english'::regconfig, (COALESCE(songs.title, ''::character varying))::text), 'C'::"char")) || setweight(to_tsvector('english'::regconfig, (COALESCE(songs.artist, ''::character varying))::text), 'C'::"char")) || setweight(to_tsvector('english'::regconfig, (COALESCE(videos.acr_cloud_track_name, ''::character varying))::text), 'C'::"char")) || setweight(to_tsvector('english'::regconfig, (COALESCE(videos.acr_cloud_artist_name, ''::character varying))::text), 'C'::"char")) || setweight(to_tsvector('english'::regconfig, (COALESCE(videos.description, ''::character varying))::text), 'C'::"char")) || setweight(to_tsvector('english'::regconfig, COALESCE(videos.title, ''::text)), 'A'::"char")) || setweight(to_tsvector('english'::regconfig, (COALESCE(videos.youtube_artist, ''::character varying))::text), 'B'::"char")) || setweight(to_tsvector('english'::regconfig, (COALESCE(videos.youtube_id, ''::character varying))::text), 'B'::"char")) || setweight(to_tsvector('english'::regconfig, (COALESCE(videos.youtube_song, ''::character varying))::text), 'B'::"char")) || setweight(to_tsvector('english'::regconfig, (COALESCE(videos.spotify_artist_name, ''::character varying))::text), 'B'::"char")) || setweight(to_tsvector('english'::regconfig, (COALESCE(videos.spotify_track_name, ''::character varying))::text), 'B'::"char")) || setweight(to_tsvector('english'::regconfig, (COALESCE(videos.tags, ''::character varying))::text), 'B'::"char")) AS tsv_content_tsearch
     FROM (((((((videos
       LEFT JOIN channels ON ((channels.id = videos.channel_id)))
       LEFT JOIN leaders ON ((leaders.id = videos.leader_id)))
       LEFT JOIN followers ON ((followers.id = videos.follower_id)))
       LEFT JOIN songs ON ((songs.id = videos.song_id)))
       LEFT JOIN events ON ((events.id = videos.event_id)))
       JOIN dancer_videos ON ((dancer_videos.video_id = videos.id)))
       JOIN dancers ON ((dancers.id = dancer_videos.dancer_id)))
    GROUP BY videos.id, channels.id, songs.id, events.id, leaders.id, followers.id;
  SQL
  add_index "video_searches", ["tsv_content_tsearch"], name: "index_video_searches_on_tsv_content_tsearch", using: :gin
  add_index "video_searches", ["video_id"], name: "index_video_searches_on_video_id", unique: true

end
