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
    performance_date.strftime("%B %Y")
  end

  def link_to_query(external_song_attributes)
    link_to external_song_attributes,
            root_path(query: external_song_attributes.gsub(/\s-\s/, " ")),
            { "data-turbo-frame": "_top" }
  end

  def link_to_song_id(song_attributes, video)
    link_to song_attributes,
            root_path(song_id: video.song_id),
            { "data-turbo-frame": "_top" }
  end

  def link_to_song(el_recodo_attributes, external_song_attributes, video)
    if el_recodo_attributes.present?
      link_to_song_id(el_recodo_attributes, video)
    elsif external_song_attributes.present?
      link_to_query(external_song_attributes)
    end
  end

  def link_to_primary_title(dancer_names, title, song_attributes, youtube_id)
    if dancer_names.present? && song_attributes.present?
      link_to dancer_names,
              watch_path(v: youtube_id),
              { "data-turbo-frame": "_top" }
    else
      link_to truncate(title, length: 85),
              watch_path(v: youtube_id),
              { "data-turbo-frame": "_top" }
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
    "#{formatted_performance_date(video.performance_date)} • #{formatted_view_count(video.view_count)} views • #{formatted_view_count(video.like_count)} likes #{performance_number(video)}"
  end

  def performance_number(video)
    if video.performance_number.present? & video.performance_total_number.present?
      " • #{video.performance_number} / #{video.performance_total_number}"
    end
  end

  def hd_duration_data(video)
    if video.hd?
      "HD #{Time.at(video.duration).utc.strftime('%M:%S')}"
    else
      Time.at(video.duration).utc.strftime("%M:%S")
    end
  end

  def channel_title(video)
    truncate(video.channel.title, length: 45, omission: "")
  end

  def sortable(column, direction, title = "", search)
    title ||= column.titleize
    column == search.sort_column ? "current #{search.sort_direction}" : nil

    button_tag({ type:  "button",
                 data:  { controller: "filter",
                          action: "filter#filter",
                          "filter-sort-value": button_active?(column, direction, search) ? 0 : column,
                          "filter-direction-value": button_active?(column, direction, search) ? 0 : direction },
                 class: "videos-sortable-button" }) do
      if button_active?(column, direction, search)
        concat content_tag(:b, title.to_s)
        concat fa_icon("times", class: "videos-sortable-icon")
      else
        title
      end
    end
  end

  def button_active?(column, direction, search)
    column == search.sort_column && direction == search.sort_direction
  end

  def video_query_params
    request.params.slice(
      "channel",
      "event_id",
      "follower",
      "genre",
      "hd",
      "leader",
      "like_count",
      "orchestra",
      "popularity",
      "query",
      "song_id",
      "upload_date",
      "view_count",
      "year",
      "direction",
      "sort",
      "watched",
    )
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

    if sorting_params["sort"] == "songs.title" && sorting_params["direction"] == "asc"
      sorting_array << "Grouped By Song Title"
    end
    if sorting_params["sort"] == "songs.last_name_search" && sorting_params["direction"] == "asc"
      sorting_array << "Grouped By Orchestra"
    end
    if sorting_params["sort"] == "videos.channel_id" && sorting_params["direction"] == "asc"
      sorting_array << "Grouped By Channel"
    end
    if sorting_params["sort"] == "videos.like_count" && sorting_params["direction"] == "desc"
      sorting_array << "Most Liked"
    end
    if sorting_params["sort"] == "videos.view_count" && sorting_params["direction"] == "desc"
      sorting_array << "Most Viewed"
    end
    if sorting_params["sort"] == "videos.popularity" && sorting_params["direction"] == "desc"
      sorting_array << "Most Popular"
    end
    if sorting_params["sort"] == "videos.performance_date" && sorting_params["direction"] == "desc"
      sorting_array << "Most Recent"
    end
    if sorting_params["sort"] == "videos.performance_date" && sorting_params["direction"] == "asc"
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
end
