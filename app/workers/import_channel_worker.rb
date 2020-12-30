class ImportChannelWorker
  include Sidekiq::Worker
  sidekiq_options queue: :default

  def perform(channel_id)
    Video.import_channel(channel_id)
  end
end
