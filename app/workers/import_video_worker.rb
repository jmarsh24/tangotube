class ImportVideoWorker
  include Sidekiq::Worker
  sidekiq_options queue: :high

  def perform(youtube_id)
    Video.import_video(youtube_id)
  end
end
