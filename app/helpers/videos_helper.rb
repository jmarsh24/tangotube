# frozen_string_literal: true

module VideosHelper
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
