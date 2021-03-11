class Event::Tangopolix::Page
  TANGOPOLIX_URL_PREFIX = "https://www.tangopolix.com/archived-events/page-".freeze
  TANGOPOLIX_ARTICLE_METADATA_HTML_MARKER = "article".freeze
  TANGOPOLIX_TITLE_HTML_MARKER = "h1 a".freeze
  TANGOPOLIX_DATE_HTML_MARKER = "span.uk-icon-calendar".freeze
  TANGOPOLIX_LOCATION_HTML_MARKER = "span.uk-icon-medium".freeze
  TANGOPOLIX_CATEGORY_HTML_MARKER = "div.uk-vertical-align-bottom a".freeze

  def initialize(id)
    @id = id
  end

  def create_events_from_tangopolix
    articles_metadata.each do |article|
      Event.create(title:      title(article),
                   city:       city(article),
                   country:    country(article),
                   start_date: start_date(article),
                   end_date:   end_date(article),
                   category:   category(article))
    end
  end

  private

  def title(article)
    @title ||= article.css(TANGOPOLIX_TITLE_HTML_MARKER).text.strip
  end

  def location(article)
    @location ||= article.css(TANGOPOLIX_LOCATION_HTML_MARKER).text.split(",").map(&:strip)
  end

  def city(article)
    return if location(article)[0].blank?

    @city ||= location(article)[0]
  end

  def country(article)
    return if location(article)[1].blank?

    @country ||= location(article)[1]
  end

  def date(article)
    @date ||= article.css(TANGOPOLIX_DATE_HTML_MARKER).text.strip.split("-").map(&:strip)
  end

  def start_date(article)
    return if date(article)[0].blank?

    @start_date ||= date(article)[0]
  end

  def end_date(article)
    return if date(article)[1].blank?

    @end_date ||= date(article)[1]
  end

  def category(article)
    @category ||= article.css(TANGOPOLIX_CATEGORY_HTML_MARKER).text
  end

  def articles_metadata
    @article_metadata ||= parsed_body.css(TANGOPOLIX_ARTICLE_METADATA_HTML_MARKER)
  end

  def parsed_body
    @parsed_body ||= ::Nokogiri::HTML(raw.body)
  end

  def raw
    ::Faraday.get(TANGOPOLIX_URL_PREFIX + @id.to_s)
  end
end
