class ImportChannelWorker
  include Sidekiq::Worker
  sidekiq_options queue: :default, retry: 3

  def perform(channel_id)
    Video::YoutubeImport::Channel.import(channel_id)
  end
end
