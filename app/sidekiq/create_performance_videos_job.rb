class CreatePerformanceVideosJob
  include Sidekiq::Job

  def perform(channel_id)
    channel = Channel.find(channel_id)
    channel.videos.group_by(&:upload_date).each do |upload_date, videos_with_same_upload_date|
      if videos_with_same_upload_date.length > 1
        performance = Performance.create
        videos_with_same_upload_date.sort_by(&:upload_date).each_with_index do |video, index|
          index = index + 1
          PerformanceVideo.create(performance: performance, video: video, position: video&.performance_number || index )
          performance.date = video&.performance_date
          performance.save
        end
      end
    end
  end
end
