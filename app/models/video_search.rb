class VideoSearch
  attr_reader :filtering_params, :sorting_params

  SEARCHABLE_COLUMNS = [
    "songs.title",
    "songs.last_name_search",
    "videos.updated_at",
    "videos.popularity",
    "videos.upload_date"
  ].freeze

  def initialize(filtering_params:, sorting_params:)
    @filtering_params = filtering_params
    @sorting_params = sorting_params
  end

  def videos
    Video.includes(Video.search_includes)
      .order(ordering_params)
      .filter_by(filtering_params)
  end

  def leaders
    @leaders ||= facet("dancers.name", {dancer_videos: :dancer}, role: :leader)
  end

  def followers
    @followers ||= facet("dancers.name", {dancer_videos: :dancer}, role: :follower)
  end

  def orchestras
    @orchestras ||= facet("songs.artist", :song)
  end

  def genres
    @genres ||= facet("songs.genre", :song)
  end

  def years
    @years ||= facet_on_column("upload_date", "year")
  end

  def songs
    @songs ||= facet("songs.title", :song)
  end

  private

  def ordering_params
    if filtering_params.empty? && sorting_params.empty?
      "RANDOM()"
    else
      sort_column = SEARCHABLE_COLUMNS.include?(sorting_params[:sort]) ? sorting_params[:sort] : "videos.popularity"
      sort_direction = ["asc", "desc"].include?(sorting_params[:direction]) ? sorting_params[:direction] : "desc"
      "#{sort_column} #{sort_direction}"
    end
  end

  def filtered_videos
    Video.filter_by(filtering_params).not_hidden
  end

  def select_facet_counts(query, videos, table_column)
    videos.select(query)
      .group(table_column)
      .having("COUNT(#{table_column}) > 0")
      .load_async
  end

  def facet(table_column, model, role: nil)
    query = "#{table_column} AS facet_value, COUNT(#{table_column}) AS occurrences"
    videos = filtered_videos.joins(model)
    videos = videos.merge(Video.where(dancer_videos: {role:})) if role.present?
    counts = select_facet_counts(query, videos, table_column)
    format_facet_counts(counts, table_column)
  end

  def facet_on_column(table_column, facet_column)
    query = "extract(#{facet_column} from #{table_column})::int AS facet_value, count(#{table_column}) AS occurrences"
    counts = filtered_videos.select(query).group("facet_value").having("count(#{table_column}) > 0").load_async
    format_facet_counts(counts, "facet_value")
  end

  def format_facet_counts(counts, table_column)
    counts.map do |c|
      facet_value = c.facet_value.to_s.downcase.tr(" ", "-")
      [format_facet_value(c.facet_value, c.occurrences).to_s, facet_value]
    end
  end

  def format_facet_value(facet_value, occurrences)
    facet_value = facet_value.to_s
    "#{facet_value.split("'").map(&:titleize).join("'")} (#{occurrences})"
  end
end
