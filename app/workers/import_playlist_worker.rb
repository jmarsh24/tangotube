class ImportPlaylistWorker
  include Sidekiq::Worker
  sidekiq_options queue: :default, retry: 3

  def perform(slug)
    Video::YotutubeImport::Playlist.import(slug)
  end
end
