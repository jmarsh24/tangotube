class MatchEventWorker
  include Sidekiq::Worker
  sidekiq_options queue: :high, retry: 1

  def perform(event_id)
    Event.match_event(event_id)
  end
end
