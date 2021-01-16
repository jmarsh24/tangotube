class UpdateHdColumnWorker
  include Sidekiq::Worker

  def perform(youtube_id)
    Video.update_video_hd(youtube_id)
  end
end
