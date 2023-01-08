# frozen_string_literal: true

class ImportVideoJob < ApplicationJob
  queue_as :low_priority
  sidekiq_options queue: :high, retry: 1

  def perform(youtube_id)
    Video::YoutubeImport.from_video(youtube_id)
  end
end
