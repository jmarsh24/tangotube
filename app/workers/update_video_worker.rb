class UpdateVideoWorker
  include Sidekiq::Worker
  sidekiq_options queue: :low, retry: 3

  def perform(youtube_id)
    Video::YoutubeImport::Video.update(youtube_id)
  end
end
