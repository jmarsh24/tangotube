class MetadataMigrationJob < ApplicationJob
  queue_as :default

  def perform(video_ids)
    video_ids.each do |video_id|
      video = Video.find(video_id)
      metadata = MetadataBuilder.build_metadata(video)
      puts "Saving metadata for video #{video.id}"
      video.update_columns(metadata:)
    end
  end
end
