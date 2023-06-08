class CopyMetadataAttributesToVideo < ActiveRecord::Migration[7.1]
  def up
    execute <<-SQL
      UPDATE videos 
      SET 
        upload_date_year = EXTRACT(YEAR FROM (metadata->'youtube'->>'upload_date')::timestamp),
        title = metadata->'youtube'->>'title',
        description = metadata->'youtube'->>'description',
        hd = (metadata->'youtube'->>'hd')::boolean,
        youtube_view_count = (metadata->'youtube'->>'view_count')::integer,
        youtube_like_count = (metadata->'youtube'->>'like_count')::integer,
        youtube_tags = ARRAY(
          SELECT jsonb_array_elements_text(metadata->'youtube'->'tags')
        ),
        duration = (metadata->'youtube'->>'duration')::integer
      WHERE metadata IS NOT NULL AND (metadata->'youtube') IS NOT NULL AND (metadata->'youtube'->'tags') IS NOT NULL;
    SQL
  end
end
