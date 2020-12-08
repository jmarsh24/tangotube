class EventScraperWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(offset, limit)
    title = []
    location = []
    date = []
    event_type = []

    [*offset..limit].each do |pagenum|
      html = Faraday.new.get("https://www.tangopolix.com/archived-events/page-#{pagenum}", request: { timeout: 120 }).body
      # html = URI.open("https://www.tangopolix.com/archived-events/page-#{pagenum}").read
      doc = Nokogiri::HTML(html)

      title << doc.search('h1.uk-article-title').inner_text.delete("\t").delete("\n").split('   ').reject!(&:empty?).collect(&:strip)
      location << doc.search('span.uk-icon-medium').map(&:text).collect(&:strip)
      date << doc.search('span.uk-icon-calendar.uk-icon-small').map(&:text).collect(&:strip)
      event_type << doc.search('div.uk-width-6-10 div a').map(&:text).collect(&:strip)
    end

    attributes = %w[title location date event_type]
    title = title.flatten
    location = location.flatten
    date = date.flatten
    event_type = event_type.flatten
    CSV.open("~/environment/data/events/eventinfo_#{offset}_#{limit}.csv", 'a', headers: true) do |csv|
      csv << attributes
      [title, location, date, event_type].transpose.each do |row|
        csv << row
      end
    end
  end
end
