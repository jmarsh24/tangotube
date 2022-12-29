class ImportVideoWorker
  include Sidekiq::Worker
  include Sidekiq::Throttled::Worker
  sidekiq_options queue: :high, retry: 1

  sidekiq_throttle(
    concurrency: { limit: 5 }
  )

  def perform(youtube_id)
    Video::YoutubeImport.from_video(youtube_id)
  end
end
