# frozen_string_literal: true

class Video::Sort
  attr_writer :video_relation
  
  COLUMN_ASSOCIATIONS = [:channel, :orchestra, :performance, :song].freeze

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

  def apply_sort
    return video_relation if sorting_params.blank?

    column = translate_column(sorting_params[:sort])
    direction = sorting_params[:direction]

    raise ArgumentError, "Invalid sort column" unless COLUMN_TRANSLATIONS.has_key?(column.to_sym)
    raise ArgumentError, "Invalid sort direction" unless [:asc, :desc].include?(direction.to_sym)

    video_relation = join_association(column) if requires_join?(column)

    self.video_relation = video_relation.order(column => direction)

    video_relation
  end

  private

  def requires_join?(column)
    COLUMN_ASSOCIATIONS.include?(column.to_sym) || column
  end

  def join_association(column)
    case column
    when "song"
      video_relation.joins(:song)
    when "performance"
      video_relation.joins(:performance_video)
    when "channel"
      video_relation.joins(:channel)
    when "orchestra"
      video_relation.joins(song: :orchestra)
    else
      video_relation
    end
  end

  def translate_column(column)
    COLUMN_TRANSLATIONS[column] || column
  end
end
