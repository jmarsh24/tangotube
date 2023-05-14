class VideoSearch
  attr_reader :filtering_params, :sorting_params

  SEARCHABLE_COLUMNS = [
    "songs.title",
    "songs.last_name_search",
    "videos.updated_at",
    "videos.popularity",
    "videos.upload_date"
  ].freeze

  def initialize(filtering_params: {}, sorting_params: {sort: "videos.popularity", direction: "desc"})
    @filtering_params = filtering_params
    @sorting_params = sorting_params
  end

  def videos
    filtered_videos
      .order(ordering_params)
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
    Video.includes(Video.search_includes)
      .featured
      .limit(limit)
      .order("random()")
  end

  private

  def ordering_params
    "#{sorting_params[:sort]} #{sorting_params[:direction]}"
  end

  def filtered_videos
    videos = Video.joins(Video.search_includes).distinct

    videos = filter_by_channel(videos)
    videos = filter_by_event_id(videos)
    videos = filter_by_leader(videos)
    videos = filter_by_follower(videos)
    videos = filter_by_song_id(videos)
    videos = filter_by_song(videos)
    videos = filter_by_genre(videos)
    videos = filter_by_upload_year(videos)
    videos.distinct
  end

  def filter_by_genre(videos)
    genre = filtering_params[:genre]
    return videos unless genre.present?

    videos.joins(:song).where("songs.genre ILIKE ?", genre)
  end

  def filter_by_channel(videos)
    channel_id = filtering_params[:channel_id]
    return videos unless channel_id.present?

    videos.joins(:channel).where(channel_id:)
  end

  def filter_by_event_id(videos)
    event_id = filtering_params[:event_id]
    return videos unless event_id.present?

    videos.joins(:event).where(event_id:)
  end

  def filter_by_leader(videos)
    leader_name = filtering_params[:leader]
    return videos unless leader_name.present?

    videos.joins(:dancer).where(id: DancerVideo.with_role(:leader).joins(:dancer).where("dancers.name ILIKE ?", leader_name).select(:video_id))
  end

  def filter_by_follower(videos)
    follower_name = filtering_params[:follower]
    return videos unless follower_name.present?

    videos.join(:dancers).where(id: DancerVideo.with_role(:follower).joins(:dancer).where("dancers.name ILIKE ?", leader_name).select(:video_id))
  end

  def filter_by_song_id(videos)
    song_id = filtering_params[:song_id]
    return videos unless song_id.present?

    videos.where(song_id:)
  end

  def filter_by_song(videos)
    song_name = filtering_params[:song]
    return videos unless song_name.present?

    videos.joins(:song).where("unaccent(songs.title) ILIKE unaccent(?)", song_name)
  end

  def filter_by_upload_year(videos)
    year = filtering_params[:year]
    return videos unless year.present?

    videos.where("extract(year from upload_date) = ?", year.to_i)
  end

  def select_facet_counts(query, videos, table_column)
    videos.select(query)
      .group(table_column)
      .having("COUNT(#{table_column}) > 0")
      .load_async
  end

  def facet(table_column, model, role: nil)
    query = "#{table_column} AS facet_value, COUNT(DISTINCT videos.id) AS occurrences"
    videos = filtered_videos.joins(model)
    videos = videos.merge(Video.where(dancer_videos: {role:})) if role.present?
    counts = select_facet_counts(query, videos, table_column)
    format_facet_counts(counts, table_column)
  end

  def facet_on_column(table_column, facet_column)
    query = "extract(#{facet_column} from #{table_column})::int AS facet_value, count(DISTINCT videos.id) AS occurrences"
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
