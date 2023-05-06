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
    link_to external_song_attributes,
      root_path(query: external_song_attributes.gsub(/\s-\s/, " ")),
      "data-turbo-frame": "_top",
      class: "tag tag--sm"
  end

  def link_to_song_slug(song_attributes, video)
    link_to song_attributes,
      root_path(song: video.song.slug),
      "data-turbo-frame": "_top",
      class: "tag tag--sm"
  end

  def link_to_song(el_recodo_attributes, external_song_attributes, video)
    if el_recodo_attributes.present?
      link_to_song_slug(el_recodo_attributes, video)
    elsif external_song_attributes.present?
      link_to_query(external_song_attributes)
    end
  end

  def link_to_primary_title(dancer_names, title, song_attributes, youtube_id)
    if dancer_names.present? && song_attributes.present?
      link_to dancer_names,
        watch_path(v: youtube_id),
        {"data-turbo-frame": "_top"}
    else
      link_to truncate(title, length: 85),
        watch_path(v: youtube_id),
        {"data-turbo-frame": "_top"}
    end
  end

  def primary_title(dancer_names, title, song_attributes, _youtube_id)
    if dancer_names.present? && song_attributes.present?
      dancer_names
    else
      title
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
    (column == sort_column) ? "current #{sort_direction}" : nil
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

    dancer_array = []
    orchestra_array = []
    year_array = []
    user_attribute_array = []
    sorting_array = []
    genre_array = []

    filtering_params.each do |key, value|
      if key == "query"
        words_array << "\"#{value}\""
      end
      if key == "liked" && value == "true"
        user_attribute_array << "Most Liked"
      end
      if key == "watched" && value == "true"
        user_attribute_array << "Watched"
      end
      if key == "watched" && value == "false"
        user_attribute_array << "New to You"
      end
      if key == "hd" && value == "1"
        user_attribute_array << "HD"
      end
      if key == "genre"
        genre_array << value
      end
      if key == "leader"
        dancer_array << value
      end
      if key == "follower"
        dancer_array << value
      end
      if key == "orchestra"
        orchestra_array << value
      end
      if key == "year"
        year_array << value
      end
    end

    if sorting_params["sort"] == "song_titile" && sorting_params["direction"] == "asc"
      sorting_array << "Grouped By Song Title"
    end
    if sorting_params["sort"] == "orchestra" && sorting_params["direction"] == "asc"
      sorting_array << "Grouped By Orchestra"
    end
    if sorting_params["sort"] == "channel" && sorting_params["direction"] == "asc"
      sorting_array << "Grouped By Channel"
    end
    if sorting_params["sort"] == "like_count" && sorting_params["direction"] == "desc"
      sorting_array << "Most Liked"
    end
    if sorting_params["sort"] == "view_count" && sorting_params["direction"] == "desc"
      sorting_array << "Most Viewed"
    end
    if sorting_params["sort"] == "popularity" && sorting_params["direction"] == "desc"
      sorting_array << "Most Popular"
    end
    if sorting_params["sort"] == "year" && sorting_params["direction"] == "desc"
      sorting_array << "Most Recent"
    end
    if sorting_params["sort"] == "year" && sorting_params["direction"] == "asc"
      sorting_array << "Oldest"
    end

    words_array << dancer_array.join(" & ")
    words_array << orchestra_array.join(": ")
    words_array << year_array.join(": ")
    words_array << user_attribute_array.join(": ")
    words_array << sorting_array.join(": ")
    words_array << genre_array.join(":")

    words_array.flatten.compact_blank.map(&:titleize).join(" - ")
  end

  def filtering_for_dancer?
    return true if filtering_params.include?(:dancer) || filtering_params.include?(:follower)
  end
end
