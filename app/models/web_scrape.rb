class WebScrape < ApplicationRecord
  class << self
    def tangopolix_events
      (1..469).each do |id|
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
end
