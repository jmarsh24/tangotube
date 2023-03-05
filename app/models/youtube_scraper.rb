# frozen_string_literal: true

require "capybara/cuprite"

class YoutubeScraper
  MUSIC_ROW_SELECTOR = "#info-row-header"
  MUSIC_ROW_DATA_SELECTOR = "#default-metadata"
  MUSIC_TOW_TITLE_SELECTOR = "#title"
  YOUTUBE_URL_PREFIX = "https://www.youtube.com/watch?v="
  RETRY_COUNT = 100

  def video_metadata(slug)
    youtube_video = Yt::Video.new id: slug

    YoutubeVideoMetadata.new(
      slug: youtube_video.id,
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
      song: song(slug),
      thumbnail_url: ThumbnailUrl.new(
        default: youtube_video.thumbnail_url(:default),
        medium: youtube_video.thumbnail_url(:medium),
        high: youtube_video.thumbnail_url(:high),
        standard: youtube_video.thumbnail_url(:standard),
        maxres: youtube_video.thumbnail_url(:maxres)
      )
    )
  end

  private

  def song(slug)
    song_metadata = SongMetadata.new

    music_html_nodes(slug).each do |row|
      attribute_name = row.find_css(MUSIC_TOW_TITLE_SELECTOR)[0].all_text
      attribute_value = row.find_css(MUSIC_ROW_DATA_SELECTOR)[0].all_text

      case attribute_name.downcase
      when "album"
        song_metadata.album = attribute_value
      when "artist"
        song_metadata.artist = attribute_value
      when "song"
        song_metadata.title = attribute_value
      end
    end

    song_metadata
  end

  def music_html_nodes(slug)
    @driver ||= Capybara::Cuprite::Driver.new(app: nil, browser_options: {headless: true})
    @driver.headers = {"Accept-Language": "en"}
    @driver.visit url(slug)

    music_elements = []
    retries = 0

    while retries < RETRY_COUNT || music_elements.empty?
      retries += 1

      sleep 0.1

      music_elements = @driver.find_css(MUSIC_ROW_SELECTOR)
    end
    music_elements
  end

  def url(slug)
    (YOUTUBE_URL_PREFIX + slug).to_s
  end
end
