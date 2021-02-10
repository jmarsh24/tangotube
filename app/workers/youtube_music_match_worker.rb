class YoutubeMusicMatchWorker
  include Sidekiq::Worker
  sidekiq_options queue: :default, retry: false

  def perform(youtube_id)
    Video.fetch_youtube_song(youtube_id)
  end
end
