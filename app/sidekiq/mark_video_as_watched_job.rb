class MarkVideoAsWatchedJob
  include Sidekiq::Job
  sidekiq_options queue: :high, retry: true

  def perform(youtube_id, user_id)
    # set video as watched
    video = Video.find_by(youtube_id:)
    video.upvote_by(User.find(user_id), vote_scope: "watchlist")
  end
end
