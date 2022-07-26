class ReindexAllResourcesJob
  include Sidekiq::Job

  def perform
    Leader.reindex!
    Follower.reindex!
    Song.reindex!
    Event.reindex!
    Video.all.find_each do |video|
      MySidekiqJob.perform_async(video.id)
    end
  end
end
