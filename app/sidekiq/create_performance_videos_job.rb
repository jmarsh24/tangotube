class CreatePerformanceVideosJob
  include Sidekiq::Job

  def perform(video_id)
    video = Video.find(video_id)
    performance_videos =
    Video.includes(:dancers, :performance)
          .references(:dancers, :performance)
          .where("upload_date <= ?", video.upload_date + 7.day)
          .where("upload_date >= ?", video.upload_date - 7.day)
          .where(dancers: { id: video.dancers.map(&:id) })
          .order(performance_number: :asc)
          .where(hidden: false)
          .where(performance: { id: nil })

      if performance_videos.length > 1
        performance = Performance.create
        performance_videos.each_with_index do |performance_video, index|
        index += 1
        PerformanceVideo.create(performance:, video: performance_video, position: video&.performance_number || index )
        performance.date = video&.performance_date
        performance.save
      end
    end
  end
end


