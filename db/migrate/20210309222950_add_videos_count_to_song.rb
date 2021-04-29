class AddVideosCountToSong < ActiveRecord::Migration[6.1]
  def change
    add_column :songs, :videos_count, :integer, default: 0, null: false

    reversible { |dir| dir.up { data } }
  end

  def data
    execute <<-SQL.squish
        UPDATE songs
            SET videos_count = (SELECT count(1)
                                    FROM videos
                                    WHERE videos.song_id = songs.id)
    SQL
  end
end
