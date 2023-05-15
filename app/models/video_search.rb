# frozen_string_literal: true

class VideoSearch
  attr_reader :filtering_params, :sorting_params

  FACETS = [:leaders, :followers, :orchestras, :genres, :years, :songs].freeze

  def initialize(filtering_params: {}, sorting_params: {sort: "videos.popularity", direction: "desc"})
    @filtering_params = filtering_params
    @sorting_params = sorting_params
  end

  FACETS.each do |facet|
    define_method(facet) do
      instance_variable_get("@#{facet}") || instance_variable_set("@#{facet}", send("facet_#{facet}"))
    end
  end

  def videos
    filtered_videos.order(ordering_params)
  end

  def paginated_videos(page, per_page:)
    videos.page(page).without_count.per(per_page)
  end

  def has_more_pages?(videos)
    videos.next_page.present?
  end

  def next_page(videos)
    videos.next_page
  end

  def featured_videos(limit)
    Video.includes(Video.search_includes).featured.limit(limit).order("random()")
  end

  private

  def ordering_params
    "#{sorting_params[:sort]} #{sorting_params[:direction]}"
  end

  def filtered_videos
    videos = Video.joins(Video.search_includes)
    filtering_params.each do |key, value|
      videos = send("filter_by_#{key}", videos, value) if value.present?
    end
    videos.distinct
  end

  [:channel, :event_id, :song_id].each do |method|
    define_method("filter_by_#{method}") do |videos, value|
      videos.where(method => value)
    end
  end

  [:leader, :follower].each do |method|
    define_method("filter_by_#{method}") do |videos, value|
      videos.where(dancer_videos: {role: DancerVideo.roles[method]}).where("dancers.name ILIKE ?", value)
    end
  end

  [:genre, :song].each do |method|
    define_method("filter_by_#{method}") do |videos, value|
      videos.where("songs.#{method} ILIKE ?", value)
    end
  end

  def filter_by_year(videos, value)
    videos.where("extract(year from upload_date) = ?", value.to_i)
  end

  def select_facet_counts(query, videos, table_column)
    videos.select(query)
      .group(table_column)
      .having("COUNT(#{table_column}) > 0")
      .load_async
  end

  def facet_leaders
    facet("dancers.name", {dancer_videos: :dancer}, role: :leader)
  end

  def facet_followers
    facet("dancers.name", {dancer_videos: :dancer}, role: :follower)
  end

  def facet_orchestras
    facet("songs.artist", :song)
  end

  def facet_genres
    facet("songs.genre", :song)
  end

  def facet_years
    facet_on_column("upload_date", "year")
  end

  def facet_songs
    facet("songs.title", :song)
  end

  def facet(table_column, model, role: nil)
    query = "#{table_column} AS facet_value, COUNT(DISTINCT videos.id) AS occurrences"
    videos = filtered_videos.joins(model)
    videos = videos.where(dancer_videos: {role:}) if role.present?
    counts = select_facet_counts(query, videos, table_column)
    format_facet_counts(counts, table_column)
  end

  def facet_on_column(table_column, facet_column)
    query = "extract(#{facet_column} from #{table_column})::int AS facet_value, count(DISTINCT videos.id) AS occurrences"
    counts = filtered_videos.select(query).group("facet_value").having("count(#{table_column}) > 0").load_async
    format_facet_counts(counts, "facet_value")
  end

  def format_facet_counts(counts, table_column)
    counts.order("occurrences DESC").map do |c|
      facet_value = c.facet_value.to_s.downcase.tr(" ", "-")
      [format_facet_value(c.facet_value, c.occurrences).to_s, facet_value]
    end
  end

  def format_facet_value(facet_value, occurrences)
    facet_value = facet_value.to_s
    "#{facet_value.split("'").map(&:titleize).join("'")} (#{occurrences})"
  end
end
