# frozen_string_literal: true

class YoutubeScraper
  MUSIC_ROW_SELECTOR = "#info-row-header"
  MUSIC_ROW_DATA_SELECTOR = "#default-metadata"
  YOUTUBE_URL_PREFIX = "https://www.youtube.com/watch?v="
  RETRY_COUNT = 1000

  def metadata(slug)
    metadata = []

    music_elements(slug).each do |row|
      metadata << row.find_css(MUSIC_ROW_DATA_SELECTOR)[0].all_text
    end

    metadata.compact_blank!.uniq!
  end

  private

  def music_elements(slug)
    driver ||= Capybara::Cuprite::Driver.new(app: nil, browser_options: {headless: true})
    driver.visit url(slug)

    music_elements = []
    retries = 0

    while retries < RETRY_COUNT || music_elements.empty?
      retries += 1
      music_elements = driver.find_css(MUSIC_ROW_SELECTOR)
    end

    music_elements
  end

  def url(slug)
    (YOUTUBE_URL_PREFIX + slug).to_s
  end
end
