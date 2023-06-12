class ImportChannelMetadataJob < ApplicationJob
  queue_as :default

  def perform(channel)
    channel.update!(
      metadata: ExternalChannelImporter.new.fetch_metadata(channel.channel_id),
      metadata_updated_at: Time.current
    )
  end
end
