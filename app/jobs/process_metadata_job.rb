# frozen_string_literal: true

class ProcessMetadataJob < ApplicationJob
  queue_as :default

  def perform(video)
    video.update!(Import::MetadataProcessing::MetadataProcessor.new.process(video.metadata))
  end
end
