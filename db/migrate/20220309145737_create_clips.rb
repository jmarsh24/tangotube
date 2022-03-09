class CreateClips < ActiveRecord::Migration[7.0]
  def change
    create_table :clips do |t|
      t.integer :start_seconds, null: false
      t.integer :end_seconds, null: false
      t.text :title
      t.float :playback_rate, precision: 2, default: 1
      t.string :tags
      t.references :user, null: false, foreign_key: true
      t.references :video, null: false, foreign_key: true

      t.timestamps
    end
  end
end
