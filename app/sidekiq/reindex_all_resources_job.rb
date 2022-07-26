class ReindexAllResourcesJob
  include Sidekiq::Job

  def perform
    Leader.reindex!
    Follower.reindex!
    Song.reindex!
    Event.reindex!
    Video.reindex!
  end
end
