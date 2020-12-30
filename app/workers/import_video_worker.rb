class ImportVideoWorker
  include Sidekiq::Worker
  sidekiq_options queue: :default, retry: 3

  def perform(youtube_id)
    Video.import_video(youtube_id)
  end
end
