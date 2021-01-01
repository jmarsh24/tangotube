class ImportVideoWorker
  include Sidekiq::Worker
  sidekiq_options queue: :high, retry: 3

  def perform(youtube_id)
    Video.import_video(youtube_id)
  end
end
