# frozen_string_literal: true

module VideosHelper
  def formatted_view_count(view_count)
    number_to_human(
      view_count,
      format: "%n%u",
      precision: 2,
      units: {
        thousand: "K",
        million: "M",
        billion: "B"
      }
    )
  end

  def formatted_performance_date(performance_date)
    return if performance_date.blank?

    performance_date.strftime("%B %Y")
  end

  def link_to_query(external_song_attributes)
    link_to external_song_attributes, root_path(query: external_song_attributes.gsub(/\s-\s/, " ")),
      "data-turbo-frame": "_top", class: "tag tag--sm"
  end

  def link_to_song_slug(video)
    link_to video.song.full_title, root_path(song: video.song.slug),
      "data-turbo-frame": "_top", class: "tag tag--sm"
  end

  def link_to_song(video)
    if video.song.present?
      link_to_song_slug(video)
    elsif video.display.any_song_attributes.present?
      link_to_query(video.display.any_song_attributes)
    end
  end

  def link_to_primary_title(video)
    if video.dancers.present? && video.song.present?
      link_to video.dancers.map(&:name).join(" & "), watch_path(v: video.youtube_id),
        "data-turbo-frame": "_top"
    else
      link_to truncate(video.metadata.youtube.title, length: 85), watch_path(v: video.youtube_id),
        "data-turbo-frame": "_top"
    end
  end

  def primary_title(video)
    if video.dancers.present? && video.song.present?
      video.display.dancer_names
    else
      video.metadata.youtube.title
    end
  end

  def formatted_metadata(video)
    "#{formatted_performance_date(video.metadata.youtube.upload_date)} • #{formatted_view_count(video.metadata.youtube.view_count)} views • #{formatted_view_count(video.metadata.youtube.like_count)} likes"
  end

  def performance_number(video)
    if video.performance.present?
      "#{video.performance_video.position} / #{video.performance.videos_count}"
    end
  end

  def hd_duration_data(video)
    return if video.metadata.youtube.duration.blank?

    if video.metadata.youtube.hd?
      "HD #{Time.at(video&.metadata&.youtube&.duration).utc.strftime("%M:%S")}"
    else
      Time.at(video&.metadata&.youtube&.duration).utc.strftime("%M:%S")
    end
  end

  def channel_title(video)
    truncate(video.channel.title, length: 45, omission: "")
  end

  def sortable(column, direction, sort_column, sort_direction, title = "")
    title ||= column.titleize

    if column == sort_column
      "current #{sort_direction}"
    end

    link_to root_path(request.query_parameters.merge(sort: column, direction:)), class: "menu-item" do
      if link_active?(column, direction, sort_column, sort_direction)
        content_tag(:span, title.to_s)
        content_tag(:div, class: "icon icon--close icon--xs")
      else
        content_tag(:span, title.to_s)
      end
    end
  end

  def link_active?(column, direction, sort_column, sort_direction)
    column == sort_column && direction == sort_direction
  end

  def videos_header(filtering_params, sorting_params)
    words_array = []

    filtering_params.each do |key, value|
      case key
      when "query"
        words_array << "\"#{value}\""
      when "liked"
        words_array << "Most Liked" if value == "true"
      when "watched"
        words_array << ((value == "true") ? "Watched" : "New to You")
      when "hd"
        words_array << "HD" if value == "1"
      when "genre"
        words_array << value
      when "leader", "follower"
        words_array << value
      when "orchestra"
        words_array << value
      when "year"
        words_array << value
      end
    end

    case sorting_params["sort"]
    when "song_titile"
      words_array << "Grouped By Song Title" if sorting_params["direction"] == "asc"
    when "orchestra"
      words_array << "Grouped By Orchestra" if sorting_params["direction"] == "asc"
    when "channel"
      words_array << "Grouped By Channel" if sorting_params["direction"] == "asc"
    when "like_count"
      words_array << "Most Liked" if sorting_params["direction"] == "desc"
    when "view_count"
      words_array << "Most Viewed" if sorting_params["direction"] == "desc"
    when "popularity"
      words_array << "Most Popular" if sorting_params["direction"] == "desc"
    when "year"
      words_array << ((sorting_params["direction"] == "desc") ? "Most Recent" : "Oldest")
    end

    words_array.compact_blank.map(&:titleize).join(" - ")
  end

  def filtering_for_dancer?
    filtering_params.include?(:dancer) || filtering_params.include?(:follower)
  end
end
