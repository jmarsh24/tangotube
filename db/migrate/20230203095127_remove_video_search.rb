class RemoveVideoSearch < ActiveRecord::Migration[7.0]
  def change
    drop_view :video_searches, materialized: true
  end
end
