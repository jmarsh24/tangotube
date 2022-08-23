class YoutubeEventHandlerJob
  include Sidekiq::Job

  def perform(event_id)
    youtube_event = YoutubeEvent.find(event_id)
    youtube_event.handle_event
  end
end
