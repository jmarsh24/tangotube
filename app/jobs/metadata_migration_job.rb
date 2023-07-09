# frozen_string_literal: true

class MetadataMigrationJob < ApplicationJob
  queue_as :default

  def perform(video)
    video.update_column(:metadata, MetadataBuilder.build_metadata(video).as_json)
  end
end
