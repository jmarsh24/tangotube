# frozen_string_literal: true

SEARCHABLE_COLUMNS = [
  "songs.title",
  "songs.last_name_search",
  "channels.title",
  "performance_videos.performance_id",
  "videos.channel_title",
  "videos.performance_date",
  "videos.view_count",
  "videos.updated_at",
  "videos.popularity",
  "videos.like_count",
  "videos.upload_date"
].freeze

class Video::Search
  def initialize(filtering_params: {}, sorting_params: {}, user: nil)
    @filtering_params = filtering_params
    @sorting_params = sorting_params
    @user = user
  end

  def self.for(filtering_params:, sorting_params:, user:)
    new(filtering_params: filtering_params, sorting_params: sorting_params, user: user)
  end

  def videos
    @videos = Video.includes(Video.search_includes)
      .order(ordering_params)
      .filter_by(@filtering_params, @user)
  end

  def dancer_leaders
    @dancer_leaders ||= facet("dancers.name", {dancer_videos: :dancer}, role: :leader)
  end

  def dancer_followers
    @dancer_followers ||= facet("dancers.name", {dancer_videos: :dancer}, role: :follower)
  end

  def song_orchestras
    @song_orchestras ||= facet("songs.artist", :song)
  end

  def song_genres
    @song_genres ||= facet("songs.genre", :song)
  end

  def performance_years
    @performance_years ||= facet_on_year("performance_date")
  end

  def song_titles
    @song_titles ||= facet("songs.title", :song)
  end

  private

  def ordering_params
    "#{sort_column} #{sort_direction}"
  end

  def sort_column
    SEARCHABLE_COLUMNS.include?(@sorting_params[:sort]) ? @sorting_params[:sort] : "videos.popularity"
  end

  def sort_direction
    ["asc", "desc"].include?(@sorting_params[:direction]) ? @sorting_params[:direction] : "desc"
  end

  def facet_on_year(table_column)
    query = "extract(year from #{table_column})::int AS facet_value, count(#{table_column}) AS occurrences"
    counts = Video.filter_by(@filtering_params, @user)
      .not_hidden
      .select(query)
      .group("facet_value")
      .order("facet_value DESC")
      .having("count(#{table_column}) > 0")
      .load_async
    counts.map { |c| ["#{c.facet_value} (#{c.occurrences})", c.facet_value] }
  end

  def facet(table_column, model, role: nil)
    query = "#{table_column} AS facet_value, count(#{table_column}) AS occurrences"
    videos = Video.filter_by(@filtering_params, @user)
      .not_hidden
      .joins(model)
    videos = videos.merge(Video.where(dancer_videos: {role: role})) if role.present?
    counts = videos.select(query)
      .group(table_column)
      .order("occurrences DESC")
      .having("count(#{table_column}) > 0")
      .load_async
    counts.map do |c|
      ["#{c.facet_value.split("'").map(&:titleize).join("'")} (#{c.occurrences})", c.facet_value.downcase]
    end
  end
end
