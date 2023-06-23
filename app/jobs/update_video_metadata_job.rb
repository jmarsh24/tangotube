# frozen_string_literal: true

class UpdateVideoMetadataJob < ApplicationJob
  queue_as :default

  def perform
    # Depending on your DB, you may need to adjust this number. This batch size aims to balance memory usage and number of total operations.
    batch_size = 500
    Video.where(title: nil).find_in_batches(batch_size:).with_index do |videos, batch|
      ActiveRecord::Base.transaction do
        videos.each do |video|
          update_metadata(video)
        end
      end
      Rails.logger.info "Processed batch ##{batch + 1}"
    end
  end

  private

  def update_metadata(video)
    ActiveRecord::Base.connection.execute <<-SQL
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
        WHERE id = #{video.id};
    SQL
  rescue => e
    Rails.logger.error "Failed to update metadata for video ID #{video.id}: #{e.message}"
  end
end
