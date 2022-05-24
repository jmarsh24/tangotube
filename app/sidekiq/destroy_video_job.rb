class DestroyVideoJob
  include Sidekiq::Job

  def perform(youtube_id)
    Video.find_by(youtube_id: youtube_id).destroy
  end
end
