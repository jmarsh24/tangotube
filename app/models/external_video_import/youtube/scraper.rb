# frozen_string_literal: true

require "puppeteer-ruby"

module ExternalVideoImport
  module Youtube
    class Scraper
      MUSIC_ROW_SELECTOR_MULTIPLE = "#video-lockups"
      MUSIC_ROW_MULTIPLE_DATA_SELECTOR = "#video-title"
      MUSIC_ROW_SELECTOR_SINGLE = "#info-row-header"
      MUSIC_ROW_SINGLE_DATA_SELECTOR = "#default-metadata"
      MUSIC_ROW_SINGLE_TITLE_SELECTOR = "#title"
      YOUTUBE_THUMBNAIL_SELECTOR = ".ytd-thumbnail"
      YOUTUBE_URL_PREFIX = "https://www.youtube.com/watch?v="
      RETRY_COUNT = 100

      def initialize
        @browser = Puppeteer.launch(headless: true)
      end

      def video_metadata(slug:)
        youtube_video = Yt::Video.new(id: slug)

        html = Nokogiri.HTML5(retrieve_html(slug))

        VideoMetadata.new(
          slug: slug,
          title: youtube_video.title,
          description: youtube_video.description,
          upload_date: youtube_video.published_at,
          duration: youtube_video.duration,
          tags: youtube_video.tags,
          hd: youtube_video.hd?,
          view_count: youtube_video.view_count,
          favorite_count: youtube_video.favorite_count,
          comment_count: youtube_video.comment_count,
          like_count: youtube_video.like_count,
          song: extract_song_metadata(html),
          thumbnail_url: extract_thumbnail_url(youtube_video),
          recommended_video_ids: extract_recommended_video_ids(html),
          channel: extract_channel_metadata(youtube_video.channel_id)
        )
      end

      private

      def extract_channel_metadata(slug)
        youtube_channel = Yt::Channel.new(id: slug)

        ChannelMetadata.new(
          id: youtube_channel.id,
          title: youtube_channel.title,
          description: youtube_channel.description,
          published_at: youtube_channel.published_at,
          thumbnail_url: youtube_channel.thumbnail_url,
          view_count: youtube_channel.view_count,
          video_count: youtube_channel.video_count,
          videos: youtube_channel.related_playlists.first&.playlist_items&.map(&:video_id) || youtube_channel.videos.map(&:id),
          playlists: youtube_channel.playlists.map(&:id),
          related_playlists: youtube_channel.related_playlists.map(&:id),
          subscriber_count: youtube_channel.subscriber_count,
          privacy_status: youtube_channel.privacy_status
        )
      end

      def extract_thumbnail_url(youtube_video)
        ThumbnailUrl.new(
          default: youtube_video.thumbnail_url(:default),
          medium: youtube_video.thumbnail_url(:medium),
          high: youtube_video.thumbnail_url(:high),
          standard: youtube_video.thumbnail_url(:standard),
          maxres: youtube_video.thumbnail_url(:maxres)
        )
      end

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
        retries = 0

        begin
          page = @browser.pages.first || @browser.new_page
          page.goto(url(slug))

          while retries < RETRY_COUNT || page.query_selector("#related #spinner").nil?
            retries += 1

            page.evaluate("window.scrollTo(0, document.body.scrollHeight)")
            sleep(0.1)
          end

          page.content
        ensure
          page&.close
        end
      end

      def url(slug)
        "#{YOUTUBE_URL_PREFIX}#{slug}"
      end
    end
  end
end
