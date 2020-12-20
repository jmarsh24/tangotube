class ImportAllVideosJob < ApplicationJob
  queue_as :default

  def perform()
    Video.import_all_videos
  end
end
