namespace :videos do
  desc "Update videos with metadata"
  task update_metadata: :environment do
    batch_size = 1000
    Video.where("metadata IS NOT NULL AND (metadata->'youtube') IS NOT NULL AND (metadata->'youtube'->'tags') IS NOT NULL").find_in_batches(batch_size: batch_size) do |group|
      UpdateVideoMetadataJob.perform_later(group.map(&:id))
    end
  end

  desc "update categories"
  task update_categories: :environment do
    Video.where("normalized_title LIKE ?", "%entrevista%")
      .or(Video.where("normalized_title LIKE ?", "%interview%"))
      .or(Video.where("? <% normalized_title LIKE ?", "tengo una pregunta para vos"))
      .or(Video.where("? <% normalized_title LIKE ?", "documentary"))
      .update_all(category: "interview")

    Video.joins(:dancer_videos)
      .where(category: nil)
      .group('videos.id')
      .having('COUNT(dancer_videos.id) >= 2')
      .update_all(category: "performance")

    Video.where(category: nil)
      .where("normalized_title LIKE ?", "%class%")
      .where("normalized_title LIKE ?", "%clase%")
      .where("normalized_title LIKE ?", "%resume%")
      .where("normalized_title LIKE ?", "%musicality%")
      .where("normalized_title LIKE ?", "%demo%")
      .where("normalized_title LIKE ?", "%sacadas%")
      .where("normalized_title LIKE ?", "%giros%")
      .where("normalized_title LIKE ?", "%colgadas%")
      .where("normalized_title LIKE ?", "%technique%")
      .where("normalized_title LIKE ?", "%variacion%")
      .update_all(category: "class")

    Video.where(category: nil)
      .where("normalized_title LIKE ?", "%workshop%")
      .update_all(category: "workshop")
  end
end
