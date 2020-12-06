# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_11_28_222120) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "fuzzystrmatch"
  enable_extension "pg_trgm"
  enable_extension "plpgsql"
  enable_extension "unaccent"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string "namespace"
    t.text "body"
    t.string "resource_type"
    t.bigint "resource_id"
    t.string "author_type"
    t.bigint "author_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id"
  end

  create_table "admin_users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_admin_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true
  end

  create_table "dancers", force: :cascade do |t|
    t.string "first_dancer"
    t.string "second_dancer"
    t.string "title"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "events", force: :cascade do |t|
    t.string "name", null: false
    t.string "city"
    t.string "country"
    t.date "date"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "followers", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "reviewed"
    t.index ["name"], name: "index_followers_on_name"
  end

  create_table "leaders", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "reviewed"
    t.index ["name"], name: "index_leaders_on_name"
  end

  create_table "songs", force: :cascade do |t|
    t.string "genre"
    t.string "title"
    t.string "artist"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["title"], name: "index_songs_on_title"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "videos", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.text "title"
    t.string "youtube_id"
    t.bigint "leader_id"
    t.bigint "follower_id"
    t.string "description"
    t.string "channel"
    t.string "channel_id"
    t.integer "duration"
    t.date "upload_date"
    t.integer "view_count"
    t.integer "avg_rating"
    t.string "tags"
    t.bigint "song_id"
    t.string "youtube_song"
    t.string "youtube_artist"
    t.datetime "performance_date"
    t.integer "performance_number"
    t.integer "performance_total"
    t.bigint "videotype_id"
    t.bigint "event_id"
    t.string "confidence_score"
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
    t.string "spotify_artist_name_3"
    t.index ["event_id"], name: "index_videos_on_event_id"
    t.index ["follower_id"], name: "index_videos_on_follower_id"
    t.index ["leader_id"], name: "index_videos_on_leader_id"
    t.index ["song_id"], name: "index_videos_on_song_id"
    t.index ["videotype_id"], name: "index_videos_on_videotype_id"
  end

  create_table "videotypes", force: :cascade do |t|
    t.string "name", null: false
    t.string "related_keywords"
  end

end
