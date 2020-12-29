class AcrMusicMatchWorker
  include Sidekiq::Worker

  def perform(youtube_id)
    Video.acr_music_match(youtube_id)
  end
end
