class ReindexAllResourcesJob
  include Sidekiq::Job

  def perform
    Leader.reindex!
    Follower.reindex!
    Song.reindex!
    Event.reindex!
    Channel.reindex!
    Video.index
    Video.index.update_settings(
      { faceting: {
          maxValuesPerFacet: 2000
        }
      }
    )
    Video.reindex!
  end
end
