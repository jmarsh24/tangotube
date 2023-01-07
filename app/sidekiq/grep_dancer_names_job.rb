class GrepDancerNamesJob
  include Sidekiq::Job

  def perform
    Dancer.all.find_each(&:find_videos)
  end
end
