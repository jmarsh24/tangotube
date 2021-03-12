class AcrMusicMatchWorker
  include Sidekiq::Worker
  sidekiq_options queue: :default, retry: false

  def perform(youtube_id)
    Video::MusicRecognition::AcrCloud.fetch(youtube_id)
  end
end
