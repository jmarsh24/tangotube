class YoutubeMusicMatchWorker
  include Sidekiq::Worker
  sidekiq_options queue: :default, retry: false

  def perform(youtube_id)
    Video::MusicRecognition::Youtube.from_video(youtube_id)
  end
end
