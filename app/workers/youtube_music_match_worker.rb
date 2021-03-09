class YoutubeMusicMatchWorker
  include Sidekiq::Worker
  sidekiq_options queue: :default, retry: false

  def perform(youtube_id)
    Video::YoutubeDlImport.from_video(youtube_id)
  end
end
