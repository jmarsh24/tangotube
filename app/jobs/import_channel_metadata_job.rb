class ImportChannelMetadataJob < ApplicationJob
  queue_as :default

  def perform(channel)
    channel.update!(
      metadata: ExternalChannelImporter.new.import(channel.channel_id),
      imported_at: Time.current
    )
  end
end
