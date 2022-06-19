class CreateGifJob
  include Sidekiq::Job
  sidekiq_options queue: :high, retry: true

  def perform(clip_id)
    Clip.find(clip_id).create_gif
  end
end
