class Video::Sort
  attr_writer :video_relation

  COLUMN_TRANSLATIONS = {
    most_recent: {column: "videos.upload_date", direction: "desc"},
    oldest: {column: "videos.upload_date", direction: "asc"},
    most_viewed: {column: "videos.youtube_view_count", direction: "desc"},
    trending: {column: "videos.popularity", direction: "desc"},
    most_liked: {column: "videos.youtube_like_count", direction: "desc"},
    performance: {column: "performance_videos.performance_id", direction: "desc"},
    song: {column: "songs.title", direction: "asc"},
    orchestra: {column: "orchestras.name", direction: "asc"},
    channel: {column: "channels.title", direction: "asc"}
  }.freeze

  attr_reader :video_relation, :sort

  def initialize(video_relation, sort: "trending")
    @video_relation = video_relation
    @sort = sort.to_sym
  end

  def sorted_videos
    return video_relation unless COLUMN_TRANSLATIONS.key?(sort)

    column = COLUMN_TRANSLATIONS[sort][:column]
    direction = COLUMN_TRANSLATIONS[sort][:direction]

    @video_relation =
      case column
      when "songs.title"
        video_relation.joins(:song)
      when "performance_videos.performance_id"
        video_relation.joins(:performance_video)
      when "channels.title"
        video_relation.joins(:channel)
      when "orchestras.name"
        video_relation.joins(song: :orchestra)
      else
        video_relation
      end

    video_relation.order(column => direction)
  end
end
