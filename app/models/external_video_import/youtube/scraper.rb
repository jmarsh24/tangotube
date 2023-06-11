# frozen_string_literal: true

require "capybara/cuprite"

module ExternalVideoImport
  module Youtube
    class Scraper
      ScrapedData = Data.define(:song, :recommended_video_ids).freeze

      MUSIC_ROW_SELECTOR_MULTIPLE = "#video-lockups"
      MUSIC_ROW_MULTIPLE_DATA_SELECTOR = "#video-title"
      MUSIC_ROW_SELECTOR_SINGLE = "#info-row-header"
      MUSIC_ROW_SINGLE_DATA_SELECTOR = "#default-metadata"
      MUSIC_ROW_SINGLE_TITLE_SELECTOR = "#title"
      YOUTUBE_THUMBNAIL_SELECTOR = ".ytd-thumbnail"
      YOUTUBE_URL_PREFIX = "https://www.youtube.com/watch?v="
      RETRY_COUNT = 100

      def initialize(driver: Capybara::Cuprite::Driver.new(nil, {headless: true, timeout: 10.minutes, process_timeout: 10.minutes, browser: :chrome}))
        @driver = driver
      end

      def data(slug)
        html = Nokogiri.HTML5(retrieve_html(slug))

        return nil if song_metadata.empty? && recommended_video_ids.empty?

        ScrapedData.new(
          song: extract_song_metadata(html),
          recommended_video_ids: extract_recommended_video_ids(html)
        )
      end

      private

      def extract_recommended_video_ids(html)
        recommended_videos = html.css(YOUTUBE_THUMBNAIL_SELECTOR)

        recommended_videos.map do |video|
          video["href"]
        end.compact.map do |video_url|
          video_url.split("v=")[1]
        end.compact
      end

      def extract_song_metadata(html)
        song_metadata = ExternalVideoImport::Youtube::SongMetadata.new

        html.css(MUSIC_ROW_SELECTOR_MULTIPLE).each do |row|
          song_metadata.titles = row.css(MUSIC_ROW_MULTIPLE_DATA_SELECTOR).map { |title| title.text.strip }.compact
        end

        html.css(MUSIC_ROW_SELECTOR_SINGLE).each do |row|
          attribute_name = row.css(MUSIC_ROW_SINGLE_TITLE_SELECTOR).text
          attribute_value = row.css(MUSIC_ROW_SINGLE_DATA_SELECTOR).text.strip
          attribute_link = row.css(MUSIC_ROW_SINGLE_DATA_SELECTOR).css("a").map { |a| a["href"] }.first

          case attribute_name.downcase
          when "album"
            song_metadata.album = attribute_value
          when "artist"
            song_metadata.artist = attribute_value
            song_metadata.artist_url = attribute_link
          when "song"
            song_metadata.titles = [attribute_value]
            song_metadata.song_url = attribute_link
          when "writers"
            song_metadata.writers = [attribute_value]
          end
        end

        song_metadata
      end

      def retrieve_html(slug)
        @driver.headers = {"Accept-Language": "en"}
        @driver.visit(url(slug))

        retries = 0

        while retries < RETRY_COUNT || !@driver.find_css("#related #spinner").empty?
          retries += 1

          @driver.evaluate_script("window.scrollTo(0, 100000)")
          sleep 0.1
        end

        @driver.body
      end

      def url(slug)
        "#{YOUTUBE_URL_PREFIX}#{slug}"
      end
    end
  end
end
