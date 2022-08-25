class UpdateVideoWorker
  include Sidekiq::Worker
  sidekiq_options queue: :default, retry: 3

  def perform(youtube_id)
    Video::YoutubeImport::Video.update(youtube_id)
  end
end
