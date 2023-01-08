# frozen_string_literal: true

class UpdateVideoJob < ApplicationJob
  queue_as :low_priority
  sidekiq_options queue: :default, retry: 3

  def perform(youtube_id)
    Video::YoutubeImport::Video.update(youtube_id)
  end
end
