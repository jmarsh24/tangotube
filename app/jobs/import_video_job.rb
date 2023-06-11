# frozen_string_literal: true

class ImportVideoJob < ApplicationJob
  queue_as :low_priority
  sidekiq_options queue: :default, retry: 3

  def perform(youtube_slug, use_scraper: true)
    ExternalVideoImport::Importer.new.import(youtube_slug, use_scraper:)
  end
end
