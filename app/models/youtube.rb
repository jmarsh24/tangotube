# frozen_string_literal: true

class Youtube
  def initialize(slug)
    @slug = slug
    @youtube_video = youtube_video(slug)
  end

  def metadata
    {
      slug: @youtube_video.id,
      title: @youtube_video.title,
      description: @youtube_video.description,
      upload_date: @youtube_video.published_at,
      duration: @youtube_video.duration,
      tags: @youtube_video.tags,
      hd: @youtube_video.hd?,
      view_count: @youtube_video.view_count,
      favorite_count: @youtube_video.favorite_count,
      comment_count: @youtube_video.comment_count,
      like_count: @youtube_video.like_count,
      youtube_music: youtube_metadata
    }
  end

  def thumbnail
    Tempfile.create ["#{@slug}_thumbnail", ".jpg"] do |file|
      file.binmode
      yt_thumbnail = HTTParty.get thumbnail_url
    rescue OpenURI::HTTPError => err
      Rails.logger.error "Error downloading hd thumbnail for #{@slug}: #{err}"
      yt_thumbnail = HTTParty.get backup_thumbnail_url
    ensure
      file.write yt_thumbnail.body
      file.rewind
      yield file if block_given?
    end
  end

  private

  def youtube_video(slug)
    Yt::Video.new id: slug
  end

  def youtube_metadata
    YoutubeScraper.new.metadata(@slug)
  end

  def thumbnail_url
    "https://i.ytimg.com/vi/#{@slug}/hq720.jpg"
  end

  def backup_thumbnail_url
    "https://i.ytimg.com/vi/#{@slug}/hqdefault.jpg"
  end
end
