class AcrcloudMusicMatchJob
  include Sidekiq::Job
  include Sidekiq::Throttled::Worker
  sidekiq_options queue: :default, retry: 3

  sidekiq_throttle(
    concurrency: { limit: 3 },
    threshold: { limit: 10_000, period: 1.day }
  )

  def perform(*_args)
    Video::MusicRecognition::AcrCloud.fetch(@youtube_id)
  end
end
