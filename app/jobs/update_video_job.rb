# frozen_string_literal: true

class UpdateVideoJob < ApplicationJob
  queue_as :low_priority
  sidekiq_options queue: :default, retry: 3

  def perform(video)
    importer = ExternalVideoImport::Importer.new
    importer.update(video)
  end
end
