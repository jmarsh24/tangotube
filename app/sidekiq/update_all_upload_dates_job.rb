class UpdateAllUploadDatesJob
  include Sidekiq::Job

  def perform(youtube_id)
    video = Video.find_by(youtube_id:)
    yt_video = Yt::Video.new id: video.youtube_id
    video.upload_date = yt_video.published_at
    rescue Yt::Errors::NoItems => e
    if e.present?
      video.destroy
    end
    video.save
  end
end
