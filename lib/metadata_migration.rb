# frozen_string_literal: true

module MetadataMigration
  def self.migrate_metadata
    Video.find_each do |video|
      metadata = Scripts::MetadataBuilder.build_metadata(video)
      video.metadata = metadata
      video.save!
    end
  end
end
