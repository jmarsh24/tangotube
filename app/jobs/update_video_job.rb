# frozen_string_literal: true

class UpdateVideoJob < ApplicationJob
  queue_as :low_priority
  sidekiq_options queue: :default

  def perform(video)
    ExternalVideoImport::Importer.new.update(video)
  end
end
