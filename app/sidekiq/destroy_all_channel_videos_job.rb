class DestroyAllChannelVideosJob
  include Sidekiq::Job

  def perform(channel_id)
    Channel.find_by(channel_id:).destroy_all_videos
  end
end
