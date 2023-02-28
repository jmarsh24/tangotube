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
      performance_date: @youtube_video.published_at,
      view_count: @youtube_video.view_count,
      favorite_count: @youtube_video.favorite_count,
      comment_count: @youtube_video.comment_count,
      like_count: @youtube_video.like_count,
      youtube_music: youtube_metadata
    }
  end

  def thumbnail
    yt_thumbnail = URI.parse(thumbnail_url).open
  rescue OpenURI::HTTPError => err
    Rails.logger.error "Error downloading hd thumbnail for #{@slug}: #{err}"
    yt_thumbnail = URI.parse(backup_thumbnail_url).open
  ensure
    directory_name = "tmp/video_#{@slug}"
    Dir.mkdir directory_name unless File.exist?(directory_name)
    file = File.open("tmp/video_#{@slug}/#{@slug}_thumbnail.jpg", "wb")
    file.write(yt_thumbnail.read)
    file.close
    file.path
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
