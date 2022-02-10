class TranslateSongLyricsWorker
  include Sidekiq::Worker

  def perform(song_id)
    song = Song.find(song_id)
    song.translate_to_english
  end
end
