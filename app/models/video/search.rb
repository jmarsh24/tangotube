class Video::Search
  SEARCHABLE_COLUMNS = %w[
    songs.title
    songs.last_name_search
    videos.channel_id
    videos.upload_date
    videos.view_count
    videos.updated_at
    videos.popularity
  ].freeze

  NUMBER_OF_VIDEOS_PER_PAGE = 60

  class << self
    def for(filtering_params:,
            sorting_params:,
            page:)
      new(filtering_params: filtering_params, sorting_params: sorting_params, page: page)
    end
  end

  def initialize(filtering_params:,
                 sorting_params:,
                 page:)
    @filtering_params = filtering_params
    @sorting_params = sorting_params
    @page = page
  end

  def all_videos
    Video.not_hidden
         .includes(:leader, :follower, :channel, :song, :event)
         .order("#{sort_column} #{sort_direction}")
         .filter_videos(@filtering_params)
  end

  def videos
    if @sorting_params.blank? && @filtering_params.blank?
      all_videos.paginate(@page, NUMBER_OF_VIDEOS_PER_PAGE)
                .shuffle
    else
      all_videos.paginate(@page, NUMBER_OF_VIDEOS_PER_PAGE)
    end
  end

  def displayed_videos_count
    all_videos.size - (all_videos.size - (@page * NUMBER_OF_VIDEOS_PER_PAGE).clamp(0, all_videos.size))
  end

  def next_page
    all_videos.paginate(@page + 1, NUMBER_OF_VIDEOS_PER_PAGE)
  end

  def leaders
    @leaders ||= facet_id("leaders.name", "leaders.id", :leader)
  end

  def followers
    @followers ||= facet_id("followers.name", "followers.id", :follower)
  end

  def orchestras
    @orchestras ||= facet("songs.artist", :song)
  end

  def genres
    @genres ||= facet("songs.genre", :song)
  end

  def years
    @years ||= facet_on_year("upload_date")
  end

  def sort_column
    SEARCHABLE_COLUMNS.include?(@sorting_params[:sort]) ? @sorting_params[:sort] : SEARCHABLE_COLUMNS.last
  end

  def sort_direction
    %w[asc desc].include?(@sorting_params[:direction]) ? @sorting_params[:direction] : "desc"
  end

  private

  def facet_on_year(table_column)
    query = "extract(year from #{table_column})::int AS facet_value, count(#{table_column}) AS occurrences"
    counts = Video.filter_videos(@filtering_params).select(query).group("facet_value").order("facet_value DESC")
    counts.map do |c|
      ["#{c.facet_value} (#{c.occurrences})", c.facet_value]
    end
  end

  def facet(table_column, model)
    query = "#{table_column} AS facet_value, count(#{table_column}) AS occurrences"
    counts = Video.filter_videos(@filtering_params).joins(model).select(query).group(table_column).order("occurrences DESC")
    counts.map do |c|
      ["#{c.facet_value.titleize} (#{c.occurrences})", c.facet_value.downcase]
    end
  end

  def facet_id(table_column, table_column_id, model)
    query = "#{table_column} AS facet_value, count(#{table_column}) AS occurrences, #{table_column_id} AS facet_id_value"
    counts = Video.filter_videos(@filtering_params).joins(model).select(query).group(table_column, table_column_id).order("occurrences DESC")
    counts.map do |c|
      ["#{c.facet_value.titleize} (#{c.occurrences})", c.facet_id_value]
    end
  end
end
