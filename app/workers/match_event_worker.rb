class MatchEventWorker
  include Sidekiq::Worker
  sidekiq_options queue: :high, retry: 1

  def perform(event_id)
    Event.find(event_id).match_videos
  end
end
