class WebScrape < ApplicationRecord
  class << self
    def recodo_lyrics
      (1..20_000).each do |id|
        logger.info "Page Number: #{id}"

        response = Faraday.get("https://www.el-recodo.com/music?id=#{id}&lang=en")

        doc = Nokogiri::HTML(response.body)

        lyrics = doc.css("p#geniusText").text if doc.css("p#geniusText").present?

        date = doc.css("div.list-group.lead a")[0].text.strip.split[1] if doc.css("div.list-group.lead a")[0].present?

        if doc.css("div.list-group.lead a")[1].present?
          title = doc.css("div.list-group.lead a")[1].text.strip.split[1..].join(" ")
        end

        if doc.css("div.list-group.lead a")[3].present?
          artist = doc.css("div.list-group.lead a")[3].text.strip.split[1..].join(" ")
        end

        if lyrics.present?
          song = Song.where("title ILIKE ? AND artist ILIKE ?", title, artist)
          song.update(el_recodo_song_id: id, lyrics: lyrics)
        end
      end
    end
  end
end
