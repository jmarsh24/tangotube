class YoutubeScraper
  attr_reader :data

  def initialize(slug)
    @slug = slug
    @data ||= []
  end

  def self.scrape(slug)
    new(slug).tap(&:scrape)
  end

  def scrape
    driver = Capybara::Cuprite::Driver.new(app: nil, browser_options: {headless: true})
    driver.visit "https://www.youtube.com/watch?v=#{@slug}"
    music_elements = driver.find(:css, "#info-row-header")
    retries = 0
    while music_elements.empty? || retries == 1000
      retries += 1
      music_elements = driver.find(:css, "#info-row-header")
    end
    music_elements.each do |metadata_row|
      @data << metadata_row.find_css("#default-metadata")[0].all_text
    end
    @data.compact_blank!
    @data.uniq!
    driver.quit
  end
end
