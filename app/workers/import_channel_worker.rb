class ImportChannelWorker
  include Sidekiq::Worker

  def perform(channel_id)
    Video.import_channel(channel_id)
  end
end
