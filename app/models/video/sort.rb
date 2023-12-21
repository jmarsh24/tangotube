# frozen_string_literal: true

class Video::Sort
  attr_writer :video_relation

  COLUMN_TRANSLATIONS = {
    most_recent: {column: "videos.upload_date", direction: "desc"},
    oldest: {column: "videos.upload_date", direction: "asc"},
    most_viewed: {column: "videos.youtube_view_count", direction: "desc"},
    most_liked: {column: "videos.youtube_like_count", direction: "desc"},
    performance: {column: "performance_videos.position", direction: "asc"},
    song: {column: "songs.title", direction: "asc"},
    orchestra: {column: "orchestras.name", direction: "asc"},
    channel: {column: "channels.title", direction: "asc"},
    recent_trending: {column: "video_scores.score_1", direction: "desc"},
    popular_trending: {column: "video_scores.score_2", direction: "desc"},
    randomized_trending: {column: "video_scores.score_3", direction: "desc"},
    balanced_trending: {column: "video_scores.score_4", direction: "desc"},
    older_trending: {column: "video_scores.score_5", direction: "desc"}
  }.freeze

  attr_reader :video_relation, :sort

  def initialize(video_relation, sort: "recent_trending")
    @video_relation = video_relation
    @sort = sort.to_sym
  end

  def videos
    return video_relation.public_send([:recent_trending, :popular_trending, :randomized_trending, :balanced_trending, :older_trending].sample) if sort == :trending
    return video_relation unless COLUMN_TRANSLATIONS.key?(sort)

    column = COLUMN_TRANSLATIONS[sort][:column]
    direction = COLUMN_TRANSLATIONS[sort][:direction]

    @video_relation =
      case column
      when "songs.title"
        video_relation.joins(:song)
      when "performance_videos.position"
        video_relation.joins(:performance_video)
      when "channels.title"
        video_relation.joins(:channel)
      when "orchestras.name"
        video_relation.joins(song: :orchestra)
      when /^video_scores.score_\d$/
        video_relation.joins(:video_score)
      else
        video_relation
      end

    video_relation.order(column => direction)
  end
end
