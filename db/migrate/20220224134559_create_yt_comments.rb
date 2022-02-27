class CreateYtComments < ActiveRecord::Migration[7.0]
  def change
    create_table :yt_comments do |t|
      t.belongs_to :video, null: false, foreign_key: true
      t.text :body, null: false
      t.text :user_name, null: false
      t.integer :like_count, null: false, default: 0
      t.date :date, null: false
      t.string :channel_id, null: false
      t.string :profile_image_url, null: false
      t.string :youtube_id, null: false

      t.timestamps
    end
  end
end
