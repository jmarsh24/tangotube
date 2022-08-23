class CreateYoutubeEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :youtube_events do |t|
      t.jsonb :data
      t.integer :status, default: 0
      t.string :processing_errors

      t.timestamps
    end
  end
end
