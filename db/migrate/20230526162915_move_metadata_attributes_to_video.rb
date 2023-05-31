class MoveMetadataAttributesToVideo < ActiveRecord::Migration[7.1]
  def up
  execute <<-SQL
    ALTER TABLE videos 
    ADD COLUMN upload_date_year integer, 
    ADD COLUMN title text, 
    ADD COLUMN description text,
    ADD COLUMN hd boolean, 
    ADD COLUMN youtube_view_count integer, 
    ADD COLUMN youtube_like_count integer, 
    ADD COLUMN youtube_tags text[], 
    ADD COLUMN duration integer;
  SQL

  Video.find_each do |video|
    metadata = video.metadata.youtube
    next if metadata.nil?

    execute <<-SQL
      UPDATE videos 
      SET 
        upload_date_year = '#{metadata.upload_date.year}',
        title = #{ActiveRecord::Base.connection.quote(metadata.title)},
        description = #{ActiveRecord::Base.connection.quote(metadata.description)},
        hd = '#{metadata.hd || false}',
        youtube_view_count = '#{metadata.view_count || 0}',
        youtube_like_count = '#{metadata.like_count || 0}',
        youtube_tags = '{#{metadata.tags.join(',')}}',
        duration = '#{metadata.duration}'
      WHERE id = #{video.id};
    SQL
  end

  execute <<-SQL
    ALTER TABLE videos 
    ALTER COLUMN upload_date_year SET DEFAULT 0,
    ALTER COLUMN title SET NOT NULL, 
    ALTER COLUMN description SET NOT NULL,
    ALTER COLUMN hd SET DEFAULT false, SET NOT NULL, 
    ALTER COLUMN youtube_view_count SET DEFAULT 0, SET NOT NULL, 
    ALTER COLUMN youtube_like_count SET DEFAULT 0, SET NOT NULL, 
    ALTER COLUMN youtube_tags SET DEFAULT '{}', 
    ALTER COLUMN duration SET DEFAULT 0, SET NOT NULL;
  SQL
end

end
