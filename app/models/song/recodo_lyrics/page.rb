class Song::RecodoLyrics::Page
  RECODO_URL_PREFIX = "https://www.el-recodo.com/music?id=".freeze
  RECODO_URL_SUFFIX = "&lang=en".freeze
  RECODO_LYRICS_HTML_MARKER = "p#geniusText".freeze
  RECODO_METADATA_HTML_MARKER = "div.list-group.lead a".freeze

  def initialize(id)
    @id = id
  end

  def update_song_from_lyrics

    return if lyrics.blank?

    song = ::Song.where("unaccent(title) ILIKE unaccent(?) AND unaccent(artist) ILIKE unaccent(?)", title, artist).first
    return unless song

    song.update(el_recodo_song_id: @id, lyrics: lyrics)
  end

  private

  def artist
    return if metadata[3].blank?

    @artist ||= metadata[3].text.strip.split[1..].join(" ")
  end

  def title
    return if metadata[1].blank?

    @title ||= metadata[1].text.strip.split[1..].join(" ")
  end

  def metadata
    @metadata ||= parsed_body.css(RECODO_METADATA_HTML_MARKER)
  end

  def lyrics
    @lyrics ||= parsed_body.css(RECODO_LYRICS_HTML_MARKER).try(:text)
  end

  def parsed_body
    @parsed_body ||= ::Nokogiri::HTML(raw.body)
  end

  def raw
    ::Faraday.get(RECODO_URL_PREFIX + @id.to_s + RECODO_URL_SUFFIX)
  end
end
