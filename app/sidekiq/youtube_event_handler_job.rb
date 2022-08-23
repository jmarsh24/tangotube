class YoutubeEventHandlerJob
  include Sidekiq::Job

  def perform(event_id)
    YoutubeEvent.find(event_id).handle_event
  end
end
