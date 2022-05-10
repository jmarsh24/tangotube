class DestroyVideoJob
  include Sidekiq::Job

  def perform(video_id)
    Video.find(video_id).destroy
  end
end
