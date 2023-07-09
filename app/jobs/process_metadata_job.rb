# frozen_string_literal: true

class ProcessMetadataJob < ApplicationJob
  queue_as :default

  def perform(video)
    video.update!(ExternalVideoImport::MetadataProcessing::MetadataProcessor.new.process(video.metadata))
  end
end
