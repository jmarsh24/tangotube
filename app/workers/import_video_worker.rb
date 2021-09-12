class ImportVideoWorker
  include Sidekiq::Worker
  sidekiq_options queue: :high, retry: 1

  def perform(youtube_id)
    Video::YoutubeImport.from_video(youtube_id)
  end
end
