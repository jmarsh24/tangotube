class ImportChannelWorker
  include Sidekiq::Worker
  sidekiq_options queue: :default, retry: 3

  def perform(channel_id)
    Video.import_channel(channel_id)
  end
end
