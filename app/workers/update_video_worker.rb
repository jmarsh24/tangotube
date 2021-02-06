class UpdateVideoWorker
  include Sidekiq::Worker
  sidekiq_options queue: :low, retry: 1

  def perform(youtube_id)
    Video.update_video(youtube_id)
  end
end
