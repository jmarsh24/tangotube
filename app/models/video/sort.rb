class Video::Sort
  COLUMN_ASSOCIATIONS = [:channel, :orchestra, :performance, :song].freeze

  COLUMN_TRANSLATIONS = {
    "year" => "videos.upload_date_year",
    "upload_date" => "videos.upload_date",
    "song" => "songs.title",
    "orchestra" => "orchestras.name",
    "channel" => "channels.title",
    "performance" => "performance_videos.performance_id",
    "popularity" => "videos.popularity",
    "view_count" => "videos.youtube_view_count",
    "like_count" => "videos.youtube_like_count"
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

    if requires_join?(sorting_params[:sort])
      join_association(sorting_params[:sort])
    end

    self.video_relation = video_relation.order(column => direction)

    video_relation
  end

  private

  def requires_join?(column) 
    COLUMN_ASSOCIATIONS.include?(column.to_sym)
  end

  def join_association(column)
    case column
    when "song"
      video_relation = self.video_relation.joins(:song)
    when "performance"
      video_relation = self.video_relation.joins(:performance_video)
    when "channel"
      video_relation = self.video_relation.joins(:channel)
    when "orchestra"
      video_relation = self.video_relation.joins(song: :orchestra)
    end
    self.video_relation = video_relation
  end

  def translate_column(column)
    COLUMN_TRANSLATIONS[column] || column
  end

  attr_writer :video_relation
end
