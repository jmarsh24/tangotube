namespace :videos do
  desc "Update videos with metadata"
  task update_metadata: :environment do
    batch_size = 1000
    Video.where("metadata IS NOT NULL AND (metadata->'youtube') IS NOT NULL AND (metadata->'youtube'->'tags') IS NOT NULL").find_in_batches(batch_size: batch_size) do |group|
      UpdateVideoMetadataJob.perform_later(group.map(&:id))
    end
  end
end
