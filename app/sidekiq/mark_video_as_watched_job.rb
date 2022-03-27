class MarkVideoAsWatchedJob
  include Sidekiq::Job
  sidekiq_options queue: :high, retry: true

  def perform(youtube_id, user_id)
    # set video as watched
    Video.find_by(youtube_id: youtube_id).upvote_by(User.find(user_id), vote_scope: "watchlist")
  end
end
