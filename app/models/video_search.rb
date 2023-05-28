# frozen_string_literal: true

class VideoSearch
  attr_reader :filtering_params, :sorting_params

  FACETS = [:leaders, :followers, :orchestras, :genres, :years, :songs].freeze

  SEARCH_INCLUDES = [
    :dancer_videos,
    :song,
    :orchestra,
    :event,
    :channel,
    :dancers,
    :performance_video,
    :performance,
    thumbnail_attachment: :blob
  ].freeze

  def initialize(filtering_params: {}, sorting_params: {sort: "popularity", direction: "desc"})
    @filtering_params = filtering_params
    @sorting_params = sorting_params
  end

  FACETS.each do |facet|
    define_method(facet) do
      instance_variable_get("@#{facet}") || instance_variable_set("@#{facet}", send("facet_#{facet}"))
    end
  end

  def videos
    filtered_videos.order(ordering_params).distinct
  end

  def not_featured_videos
    filtered_videos.where(featured: false).order(ordering_params).distinct
  end

  def featured_videos
    subquery = filtered_videos.where(featured: true).select(:id).distinct
    Video.where(id: subquery).order("random()")
  end

  private

  def ordering_params
    "#{sorting_params[:sort]} #{sorting_params[:direction]}"
  end

  def filtered_videos
    videos = Video.left_joins(SEARCH_INCLUDES)
    return videos if filtering_params.blank?

    filtering_params.each do |key, value|
      videos = send("filter_by_#{key}", videos, value) if value.present?
    end
    videos
  end

  def filter_by_query(videos, value)
    videos.search(value)
  end

  def search(terms)
    Array.wrap(terms)
      .map { |e| e.tr("*", "").downcase }
      .reduce(self) do |scope, term|
        scope.where("index LIKE ?", "%#{term}%")
      end
  end

  def filter_by_leader(videos, value)
    leader_id = Dancer.where("slug LIKE ?", value).pluck(:id)
    videos.where(id: DancerVideo.where(role: :leader, dancer_id: leader_id).select(:video_id))
  end

  def filter_by_follower(videos, value)
    follower_id = Dancer.where("slug LIKE ?", value).pluck(:id)
    videos.where(id: DancerVideo.where(role: :follower, dancer_id: follower_id).select(:video_id))
  end

  def filter_by_song(videos, value)
    videos.where("songs.slug LIKE ?", value)
  end

  def filter_by_genre(videos, value)
    videos.where("songs.genre ILIKE ?", value)
  end

  def filter_by_orchestra(videos, value)
    videos.where("orchestras.slug LIKE ?", value)
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
      facet_value = c.facet_value.to_s.downcase.tr(" ", "-").delete("'")
      [format_facet_value(c.facet_value, c.occurrences).to_s, facet_value]
    end
  end

  def format_facet_value(facet_value, occurrences)
    facet_value = facet_value.to_s
    "#{facet_value.split("'").map(&:titleize).join("'")} (#{occurrences})"
  end
end
