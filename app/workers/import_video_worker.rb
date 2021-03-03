class ImportVideoWorker
  include Sidekiq::Worker
  sidekiq_options queue: :high, retry: 1

  def perform(youtube_id)
    Video::YoutubeImport::Video.import(youtube_id)
  end
end
