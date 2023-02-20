class Youtube
  attr_reader :data

  def initialize(slug)
    @video = Yt::Video.new id: slug
  end

  def self.fetch(slug)
    new(slug).tap(&:fetch)
  end

  def fetch
    @data = {
      youtube_id: @video.id,
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
      like_count: @video.like_count
    }
  end
end
