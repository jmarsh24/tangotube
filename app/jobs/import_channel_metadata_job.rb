# frozen_string_literal: true

class ImportChannelMetadataJob < ApplicationJob
  queue_as :default

  def perform(channel)
    channel.fetch_and_save_metadata!
  end
end
