module ApplicationHelper
  def sortable(column, title = nil)
    title ||= column.titleize
    css_class = column == sort_column ? "current #{sort_direction}" : nil
    direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
    link_to title, current_page_params.merge({ sort: column, direction: direction }), { class: css_class }
  end

  def current_page_params
    request.params.slice("songs.title",
                         "songs.artist",
                         "songs.genre",
                         "leaders.name",
                         "followers.name",
                         "youtube_id",
                         "channel",
                         "upload_date",
                         "view_count",
                         "videotypes.name",
                         "event.name",
                         "q",
                         "sort",
                         "direction",
                         "genre",
                         "videotype",
                         "leader",
                         "follower",
                         "channel",
                         "keyword")
  end

  def format_value(value)
    value ||= "N/A"
  end
end
