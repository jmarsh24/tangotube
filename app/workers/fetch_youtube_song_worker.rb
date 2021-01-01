class FetchYoutubeSongWorker
  include Sidekiq::Worker

  def perform(youtube_id)
    Video.fetch_youtube_song(youtube_id)
  end
end
