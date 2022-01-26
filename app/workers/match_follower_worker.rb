class MatchFollowerWorker
  include Sidekiq::Worker

  def perform(follower_id, follower_name)
    Video.title_match_missing_follower(follower_name).each do |video|
      video.update(follower_id: follower_id)
    end
  end
end
