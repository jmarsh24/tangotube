# frozen_string_literal: true

require "capybara/cuprite"

class YoutubeScraper
  MUSIC_ROW_SELECTOR_MULTIPLE = "#video-lockups"
  MUSIC_ROW_MULTIPLE_DATA_SELECTOR = "#video-title"
  MUSIC_ROW_SELECTOR_SINGLE = "#info-row-header"
  MUSIC_ROW_SINGLE_DATA_SELECTOR = "#default-metadata"
  MUSIC_ROW_SINGLE_TITLE_SELECTOR = "#title"
  YOUTUBE_THUMBNAIL_SELECTOR = ".ytd-thumbnail"
  YOUTUBE_URL_PREFIX = "https://www.youtube.com/watch?v="
  RETRY_COUNT = 100

  def initialize(driver: Capybara::Cuprite::Driver.new(app: nil, browser_options: {headless: true}))
    @driver = driver
  end

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
      thumbnail_url: thumbnail_url(youtube_video),
      recommended_video_ids: recommended_videos(slug),
      channel: channel_metadata(youtube_video.channel_id)
    )
  end

  private

  def channel_metadata(slug)
    youtube_channel = Yt::Channel.new id: slug

    YoutubeChannelMetadata.new(
      id: youtube_channel.id,
      title: youtube_channel.title,
      description: youtube_channel.description,
      published_at: youtube_channel.published_at,
      thumbnail_url: youtube_channel.thumbnail_url,
      view_count: youtube_channel.view_count,
      video_count: youtube_channel.video_count,
      videos: youtube_channel.related_playlists.first.playlist_items.map(&:video_id) || youtube_channel.videos.map(&:id),
      playlists: youtube_channel.playlists.map(&:id),
      related_playlists: youtube_channel.related_playlists.map(&:id),
      subscribed_channels: youtube_channel.subscribed_channels.map(&:id),
      subscriber_count: youtube_channel.subscriber_count,
      privacy_status: youtube_channel.privacy_status
    )
  end

  def thumbnail_url(youtube_video)
    ThumbnailUrl.new(
      default: youtube_video.thumbnail_url(:default),
      medium: youtube_video.thumbnail_url(:medium),
      high: youtube_video.thumbnail_url(:high),
      standard: youtube_video.thumbnail_url(:standard),
      maxres: youtube_video.thumbnail_url(:maxres)
    )
  end

  def recommended_videos(slug)
    navigate_to_video(slug)

    recommended_video_ids = []

    recommended_videos = @driver.find(:css, YOUTUBE_THUMBNAIL_SELECTOR)

    recommended_videos.map do |video|
      video&.[]("href")
    end.compact.map do |video_url|
      recommended_video_ids << video_url.split("v=")[1]
    end
    recommended_video_ids
  end

  def song(slug)
    navigate_to_video(slug)

    song_metadata = SongMetadata.new

    find_music_html_nodes(MUSIC_ROW_SELECTOR_MULTIPLE).each do |row|
      attribute_title = row.find(:css, MUSIC_ROW_MULTIPLE_DATA_SELECTOR)[0]&.all_text

      song_metadata.titles = []
      song_metadata.titles << attribute_title
    end

    find_music_html_nodes(MUSIC_ROW_SELECTOR_SINGLE).each do |row|
      attribute_name = row.find(:css, MUSIC_ROW_SINGLE_TITLE_SELECTOR)[0].all_text
      attribute_value = row.find(:css, MUSIC_ROW_SINGLE_DATA_SELECTOR)[0].all_text
      attribute_link = row.find(:css, MUSIC_ROW_SINGLE_DATA_SELECTOR)[0].find(:css, "a")[0]&.[]("href")

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

  def find_music_html_nodes(selector)
    music_elements = []
    retries = 0

    while retries < RETRY_COUNT || music_elements.empty?
      retries += 1

      sleep 0.1
      music_elements = @driver.find(:css, selector)
    end
    music_elements
  end

  def navigate_to_video(slug)
    @driver.headers = {"Accept-Language": "en"}
    @driver.visit url(slug)

    retries = 0

    while retries < RETRY_COUNT || @driver.find(:css, "#related")[0].find(:css, "#spinner").any?
      retries += 1

      @driver.evaluate_script("window.scrollTo(0,100000)")
      sleep 0.1
    end
  end

  def url(slug)
    (YOUTUBE_URL_PREFIX + slug).to_s
  end
end
