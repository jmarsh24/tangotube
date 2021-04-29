class AddVideosCountToChannel < ActiveRecord::Migration[6.1]
  def change
    add_column :channels, :videos_count, :integer, default: 0, null: false

    reversible { |dir| dir.up { data } }
  end

  def data
    execute <<-SQL.squish
        UPDATE channels
            SET videos_count = (SELECT count(1)
                                    FROM videos
                                    WHERE videos.channel_id = channels.id)
    SQL
  end
end
