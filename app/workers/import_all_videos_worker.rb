class ImportAllVideosWorker
  include Sidekiq::Worker

  def perform
    Video.import_all_videos
  end
end
