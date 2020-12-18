class ImportAllVideosWorker
  include Sidekiq::Worker

  def perform(channel_id)
    Video.import_channel(channel_id)
    Video.match_dancers
    Video.match_songs
  end
end
