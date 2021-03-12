class AddVideosCountToLeader < ActiveRecord::Migration[6.1]
  def change
    add_column :leaders, :videos_count, :integer, default: 0, null: false

    reversible do |dir|
      dir.up { data }
    end
  end

  def data
    execute <<-SQL.squish
        UPDATE leaders
            SET videos_count = (SELECT count(1)
                                    FROM videos
                                    WHERE videos.leader_id = leaders.id)
    SQL
  end
end
