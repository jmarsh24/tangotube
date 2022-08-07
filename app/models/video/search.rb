class Video::Search
  SEARCHABLE_COLUMNS = %w[
    songs.title
    songs.last_name_search
    videos.channel_title
    videos.performance_date
    videos.view_count
    videos.updated_at
    videos.popularity
    videos.like_count
  ].freeze

  NUMBER_OF_VIDEOS_PER_PAGE = 60
  NUMBER_OF_VIDEOS_PER_ROW = 10

  class << self
    def for(filtering_params:, sorting_params:, page:, user:)
      new(
        filtering_params:,
        sorting_params:,
        page:,
        user:
      )
    end
  end

  def initialize(filtering_params: {}, sorting_params: {}, page: 1, user: nil)
    @filtering_params = filtering_params
    @sorting_params = sorting_params
    @page = page
    @user = user
  end

  def videos
    @videos =
      Video
        # .not_hidden
        .includes(:leader, :follower, :channel, :song, :event)
        .order(ordering_params)
        .filter_videos(@filtering_params, @user)
        # .where.not(view_count: nil)
        return @videos unless @filtering_params.empty? && @sorting_params.empty?
    @videos.most_viewed_videos_by_month
           .has_leader
           .has_follower
  end

  def paginated_videos
    @paginated_videos = videos.paginate(@page, NUMBER_OF_VIDEOS_PER_PAGE).load_async
  end

  def paginated_row
    @paginated_videos_row = videos.paginate(@page, NUMBER_OF_VIDEOS_PER_ROW).load_async
  end

  def displayed_videos_count
    @displayed_videos_count ||= ((@page - 1) * NUMBER_OF_VIDEOS_PER_PAGE) + paginated_videos.size
  end

  def next_page?
    @next_page ||= displayed_videos_count < videos.size
  end

  def leaders
    @leaders ||= facet("leaders.name", :leader)
  end

  def followers
    @followers ||= facet("followers.name", :follower)
  end

  def orchestras
    @orchestras ||= facet("songs.artist", :song)
  end

  def genres
    @genres ||= facet("songs.genre", :song)
  end

  def years
    @years ||= facet_on_year("performance_date")
  end

  def songs
    @songs ||= facet("songs.title", :song)
  end

  def sort_column
    SEARCHABLE_COLUMNS.include?(@sorting_params[:sort]) ? @sorting_params[:sort] : "videos.popularity"
  end

  def sort_direction
    %w[asc desc].include?(@sorting_params[:direction]) ? @sorting_params[:direction] : "desc"
  end

  def filter_column
    @filtering_params
  end

  private

  def ordering_params
    @filtering_params.empty? && @sorting_params.empty? ? "RANDOM()": "#{sort_column} #{sort_direction}"
  end

  def facet_on_year(table_column)
    query =
      "extract(year from #{table_column})::int AS facet_value, count(#{table_column}) AS occurrences"
    counts =
      Video
        .filter_videos(@filtering_params, @user)
        # .not_hidden
        .select(query)
        .group("facet_value")
        .order("facet_value DESC")
        .having("count(#{table_column}) > 0")
        .load_async
    counts.map { |c| ["#{c.facet_value} (#{c.occurrences})", c.facet_value] }
  end

  def facet(table_column, model)
    query =
      "#{table_column} AS facet_value, count(#{table_column}) AS occurrences"
    counts =
      Video
        .filter_videos(@filtering_params, @user)
        # .not_hidden
        .joins(model)
        .select(query)
        .group(table_column)
        .order("occurrences DESC")
        .having("count(#{table_column}) > 0")
        .load_async
    counts.map do |c|
      ["#{c.facet_value.split("'").map(&:titleize).join("'")} (#{c.occurrences})", c.facet_value.downcase]
    end
  end

  def facet_id(table_column, table_column_id, model)
    query =
      "#{table_column} AS facet_value, count(#{table_column}) AS occurrences, #{table_column_id} AS facet_id_value"
    counts =
      Video
        .filter_videos(@filtering_params, @user)
        # .not_hidden
        .joins(model)
        .select(query)
        .group(table_column, table_column_id)
        .order("occurrences DESC")
        .having("count(#{table_column}) > 0")
        .load_async
    counts.map do |c|
      ["#{c.facet_value.titleize} (#{c.occurrences})", c.facet_id_value]
    end
  end
end
