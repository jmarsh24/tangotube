class MatchLeaderWorker
  include Sidekiq::Worker

  def perform(leader_id, leader_name)
    Video.title_match_missing_leader(leader_name).each do |video|
      video.update(leader_id: leader_id)
    end
  end
end
