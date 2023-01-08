# frozen_string_literal: true

class ImportPlaylistJob < ApplicationJob
  queue_as :low_priority
  sidekiq_options queue: :default, retry: 3

  def perform(slug)
    Video::YoutubeImport.import_playlist(slug)
  end
end
