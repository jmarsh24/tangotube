module ApplicationHelper
  def sortable(column, title = nil)
    title ||= column.titleize
    css_class = column == sort_column ? "current #{sort_direction}" : nil
    direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
    link_to title, current_page_params.merge( {sort: column, direction: direction} ), {class: css_class}
  end

  def current_page_params
    request.params.permit("songs.artist",
                          "songs.genre",
                          "leader_id",
                          "follower_id",
                          "channel",
                          "upload_date",
                          "view_count",
                          "songs.title",
                          "videotype_id",
                          "event_id",
                          "q",
                          "page",
                          "youtube_id")
  end

  def format_value(value)
    value ||= 'N/A'
  end
  
end
