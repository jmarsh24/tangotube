class AddTsvectorColumnsToVideos < ActiveRecord::Migration[6.1]
  def up
    execute <<-SQL
      ALTER TABLE videos
      ADD COLUMN searchable tsvector GENERATED ALWAYS AS (
        setweight(to_tsvector('english', coalesce(title, '')), 'A') ||
        setweight(to_tsvector('english', coalesce(description,'')), 'B')
      ) STORED;
    SQL
  end

  def down
    remove_column :videos, :searchable
  end
end
