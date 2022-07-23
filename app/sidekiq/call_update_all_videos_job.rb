class CallUpdateAllVideosJob
  include Sidekiq::Job

  def perform
    Video.all.find_each do |video|
      UpdateAllUploadDatesJob.perform_async(video.youtube_id)
    end
  end
end
