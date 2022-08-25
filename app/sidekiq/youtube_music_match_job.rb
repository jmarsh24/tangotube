class YoutubeMusicMatchJob
  include Sidekiq::Job
  include Sidekiq::Throttled::Worker
  sidekiq_options queue: :default, retry: 3

  sidekiq_throttle(
    concurrency: { limit: 3 },
  )

  def perform(*args)
    Video::MusicRecognition::Youtube.fetch(@youtube_id)
  end
end
