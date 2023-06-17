# frozen_string_literal: true

class Video::Sort
  attr_writer :video_relation

  COLUMN_TRANSLATIONS = {
    year: "videos.upload_date_year",
    upload_date: "videos.upload_date",
    song: "songs.title",
    orchestra: "orchestras.name",
    channel: "channels.title",
    performance: "performance_videos.performance_id",
    popularity: "videos.popularity",
    view_count: "videos.youtube_view_count",
    like_count: "videos.youtube_like_count"
  }.freeze

  attr_reader :video_relation, :sorting_params

  def initialize(video_relation, sorting_params: {sort: "popularity", direction: "desc"})
    @video_relation = video_relation
    @sorting_params = sorting_params
  end

  def sorted_videos
    return video_relation unless sorting_params.present?

    column = sorting_params[:sort].to_sym
    raise ArgumentError, "Invalid sort column" unless COLUMN_TRANSLATIONS.has_key?(column)

    direction = sorting_params[:direction].to_sym
    raise ArgumentError, "Invalid sort direction" unless [:asc, :desc].include?(direction)

    column = COLUMN_TRANSLATIONS[column]

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
