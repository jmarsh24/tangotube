# frozen_string_literal: true

class ImportVideoJob < ApplicationJob
  queue_as :low_priority
  sidekiq_options queue: :default, retry: 3

  def perform(youtube_slug, use_scraper: true)
    importer = ExternalVideoImport::Importer.new(use_scraper:)
    importer.import(youtube_slug)
  end
end
