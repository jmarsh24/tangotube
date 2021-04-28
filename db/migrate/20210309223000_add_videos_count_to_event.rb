class AddVideosCountToEvent < ActiveRecord::Migration[6.1]
  def change
    add_column :events, :videos_count, :integer, default: 0, null: false
    reversible { |dir| dir.up { data } }
  end

  def data
    execute <<-SQL.squish
        UPDATE events
            SET videos_count = (SELECT count(1)
                                    FROM videos
                                    WHERE videos.event_id = events.id)
    SQL
  end
end
