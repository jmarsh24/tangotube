class FetchYoutubeSongWorker
  include Sidekiq::Worker

  def perform(youtube_id)
    Video::YoutubeDlImport.from_video(youtube_id)
  end
end
