class AddVideosCountToFollower < ActiveRecord::Migration[6.1]
  def change
    add_column :followers, :videos_count, :integer, default: 0, null: false

    reversible { |dir| dir.up { data } }
  end

  def data
    execute <<-SQL.squish
        UPDATE followers
            SET videos_count = (SELECT count(1)
                                    FROM videos
                                    WHERE videos.follower_id = followers.id)
    SQL
  end
end
