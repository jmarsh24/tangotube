class YoutubeScraper
  MUSIC_ROW_SELECTOR = "#info-row-header".freeze
  MUSIC_ROW_DATA_SELECTOR = "#default-metadata".freeze
  YOUTUBE_URL_PREFIX = "https://www.youtube.com/watch?v=".freeze
  RETRY_COUNT = 1000

  attr_reader :data

  def initialize(slug)
    @slug = slug
    @data = []
    @reties = 0
    @music_elements = []
  end

  def self.scrape(slug)
    new(slug).tap(&:scrape)
  end

  def scrape
    driver.visit url

    while @reties == RETRY_COUNT || @music_elements.empty?
      @reties += 1
      @music_elements = driver.find_css(MUSIC_ROW_SELECTOR)
    end

    @music_elements.each do |row|
      @data << row.find_css(MUSIC_ROW_DATA_SELECTOR)[0].all_text
    end

    @data.compact_blank!.uniq!
  end

  private

  def driver
    @driver ||= Capybara::Cuprite::Driver.new(app: nil, browser_options: {headless: true})
  end

  def url
    (YOUTUBE_URL_PREFIX + @slug).to_s
  end
end
