class ImportCommentsWorker
  include Sidekiq::Worker
  sidekiq_options queue: :default, retry: 3

  def perform(youtube_id)
    video = Video.find_by(youtube_id:)
    yt_video = Yt::Video.new id: youtube_id
    yt_video_comment_ids = yt_video.comment_threads.take(10000).map(&:id)
    yt_video_comment_ids.each do |comment_id|
      yt_comment = Yt::Comment.new id: comment_id
      video.yt_comments.create(
        youtube_id: yt_comment.id,
        user_name: yt_comment.author_display_name,
        date: yt_comment.updated_at,
        like_count: yt_comment.like_count,
        body: yt_comment.text_display,
        channel_id: yt_comment.snippet.data["authorChannelId"].fetch("value"),
        profile_image_url: yt_comment.snippet.data["authorProfileImageUrl"]
      )
    end
  end
end
