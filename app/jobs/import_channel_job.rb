# frozen_string_literal: true

class ImportChannelJob < ApplicationJob
  queue_as :low_priority
  sidekiq_options queue: :default, retry: 3

  def perform(channel_id)
    Video::YoutubeImport.from_channel(channel_id)
  end
end
