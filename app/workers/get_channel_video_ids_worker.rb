class GetChannelVideoIdsWorker
  include Sidekiq::Worker

  def perform(channel_id)
    Video.get_channel_video_ids(channel_id)
  end
end
