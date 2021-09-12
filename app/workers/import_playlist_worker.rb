class ImportPlaylistWorker
  include Sidekiq::Worker
  sidekiq_options queue: :default, retry: 3

  def perform(slug)
    Video::YoutubeImport.import_playlist(slug)
  end
end
