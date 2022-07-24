class GrepDancerNamesJob
  include Sidekiq::Job

  def perform
    Dancer.all.find_each do |dancer|
      dancer.find_videos
    end
  end
end
