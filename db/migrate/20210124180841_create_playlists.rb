class CreatePlaylists < ActiveRecord::Migration[6.1]
  def change
    create_table :playlists do |t|
      t.string :slug
      t.string :title
      t.string :description
      t.string :channel_title
      t.string :channel_id
      t.string :video_count
      t.boolean :imported, default: false
      t.references :videos, index: true, foreign_key: true
      t.references :user, foreign_key: true
      t.timestamps
    end
  end
end
