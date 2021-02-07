class Event < ApplicationRecord
  has_many :videos

  class << self
    def scrape_events
      (14..469).each do |id|
        puts "Page Number: #{id}"
        response = Faraday.get("https://www.tangopolix.com/archived-events/page-#{id}")
        doc = Nokogiri::HTML(response.body)
        articles = doc.css('article')
        articles.each do |article|
          title = article.css('h1 a').text.strip
          location = article.css('span.uk-icon-medium').text.split(',').map(&:strip)
          city = location[0]
          country = location[1]
          date = article.css('span.uk-icon-calendar').text.split('-').map(&:strip)
          start_date = date[0]
          end_date = date[1]
          category = article.css('div.uk-vertical-align-bottom a')[0].text

          Event.create(title: title,
                       city: city,
                       country: country,
                       start_date: start_date,
                       end_date: end_date,
                       category: category)
        end
      end
    end

    def match_all_events
      Event.all.order(:id).each do |event|
        MatchEventWorker.perform_async(event.id)
      end
    end

    def match_event(event_id)
      event = Event.find(event_id)
      event_title = event.title.split('-')[0].strip

      if event_title.split.size > 3

        videos = Video.joins(:channel)
                      .where(event_id: nil)
                      .where('videos.title ILIKE ? OR videos.description ILIKE ? OR videos.tags ILIKE ? OR channels.title ILIKE ?', "%#{event_title}%",
                             "%#{event_title}%", "%#{event_title}%", "%#{event_title}%")

        videos.update_all(event_id: event.id) if videos.present?
      end
    end
  end
end
