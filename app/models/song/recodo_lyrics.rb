class Song::RecodoLyrics
  SONG_ID_MAX_NUMBER = 20_000

  class << self
    delegate :fetch, to: :new
  end

  def fetch
    (1..SONG_ID_MAX_NUMBER).each do |id|
      fetch_page(id)
    end
  end

  private

  def fetch_page(id)
    logger.info "Page Number: #{id}"

    page = Page.new(id: id)
    page.update_song_from_lyrics
  end
end
