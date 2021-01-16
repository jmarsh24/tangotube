class UpdateHdColumnWorker
  include Sidekiq::Worker

  def perform(youtube_id)
    Video.update_hd_columns(youtube_id)
  end
end
