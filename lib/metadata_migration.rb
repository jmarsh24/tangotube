# frozen_string_literal: true

module MetadataMigration
  def self.migrate_metadata
    Video.find_in_batches(batch_size: 10000) do |batch|
      Video.transaction do
        batch.each do |video|
          metadata = MetadataBuilder.build_metadata(video)
          puts "Saving metadata for video #{video.id}"
          video.update_columns(metadata:)
        end
      end
    end
  end
end
