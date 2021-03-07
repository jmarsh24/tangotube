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

    def tangopolix_events
      (14..469).each do |id|
        puts "Page Number: #{id}"
        response = Faraday.get("https://www.tangopolix.com/archived-events/page-#{id}")
        doc = Nokogiri::HTML(response.body)
        articles = doc.css("article")
        articles.each do |article|
          title = article.css("h1 a").text.strip
          location = article.css("span.uk-icon-medium").text.split(",").map(&:strip)
          city = location[0]
          country = location[1]
          date = article.css("span.uk-icon-calendar").text.split("-").map(&:strip)
          start_date = date[0]
          end_date = date[1]
          category = article.css("div.uk-vertical-align-bottom a")[0].text

          Event.create(title:      title,
                       city:       city,
                       country:    country,
                       start_date: start_date,
                       end_date:   end_date,
                       category:   category)
      end
    end
  end
end
