class RemoveLeaderFollowerTable < ActiveRecord::Migration[7.0]
  def change
    drop_table :leaders do |t|
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
    drop_table :followers do |t|
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
  end
end
