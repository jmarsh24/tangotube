class Youtube
  attr_reader :metadata

  def initialize(slug)
    @slug = slug
    @video = Yt::Video.new id: slug
  end

  def self.fetch(slug:)
    new(slug).tap(&:fetch)
  end

  def fetch
    @metadata = {
      slug: @video.id,
      title: @video.title,
      description: @video.description,
      upload_date: @video.published_at,
      duration: @video.duration,
      tags: @video.tags,
      hd: @video.hd?,
      performance_date: @video.published_at,
      view_count: @video.view_count,
      favorite_count: @video.favorite_count,
      comment_count: @video.comment_count,
      like_count: @video.like_count,
      youtube_music: youtube_metadata
    }
  end

  def thumbnail
    @thumbnail ||= begin
      yt_thumbnail = URI.parse(thumbnail_url).open
    rescue OpenURI::HTTPError
      yt_thumbnail = URI.parse(backup_thumbnail_url).open
    ensure
      directory_name = "tmp/video_#{@slug}"
      Dir.mkdir directory_name unless File.exist?(directory_name)
      file = File.open("tmp/video_#{@slug}/#{@slug}_thumbnail.jpg", "wb")
      file.write(yt_thumbnail.read)
      file.close
      file.path
    end
  end

  private

  def youtube_metadata
    YoutubeScraper.new(@slug).metadata
  end

  def thumbnail_url
    "https://i.ytimg.com/vi/#{@slug}/hq720.jpg"
  end

  def backup_thumbnail_url
    "https://i.ytimg.com/vi/#{@slug}/hqdefault.jpg"
  end
end
