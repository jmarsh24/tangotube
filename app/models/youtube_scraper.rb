class YoutubeScraper
  MUSIC_ROW_SELECTOR = "#info-row-header".freeze
  MUSIC_ROW_DATA_SELECTOR = "#default-metadata".freeze
  YOUTUBE_URL_PREFIX = "https://www.youtube.com/watch?v=".freeze
  RETRY_COUNT = 1000

  def initialize(slug)
    @slug = slug
    @reties = 0
  end

  def metadata
    driver.visit url

    @metadata ||= music_row_data.compact_blank!.uniq!
  end

  private

  def music_row_data
    metadata = []

    music_elements.each do |row|
      metadata << row.find_css(MUSIC_ROW_DATA_SELECTOR)[0].all_text
    end

    metadata
  end

  def music_elements
    music_elements = []

    while @reties == RETRY_COUNT || music_elements.empty?
      @reties += 1
      music_elements = driver.find_css(MUSIC_ROW_SELECTOR)
    end

    music_elements
  end

  def driver
    @driver ||= Capybara::Cuprite::Driver.new(app: nil, browser_options: {headless: true})
  end

  def url
    (YOUTUBE_URL_PREFIX + @slug).to_s
  end
end
