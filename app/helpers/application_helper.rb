module ApplicationHelper
  def sortable(column, title = nil)
    title ||= column.titleize
    css_class = column == sort_column ? "current #{sort_direction}" : nil
    direction = column == sort_column && sort_direction == 'asc' ? 'desc' : 'asc'
    link_to "#{title} #{if css_class.present?
                          content_tag(:i, '', class: "fa fa-chevron-#{direction == 'asc' ? 'up' : 'down'}")
                        end}".html_safe,
            current_page_params.merge({ sort: column, direction: direction }), { class: css_class }
  end

  def current_page_params
    request.params.slice('songs.title',
                         'songs.artist',
                         'songs.genre',
                         'songs.last_name_search',
                         'leaders.name',
                         'followers.name',
                         'ochestra',
                         'channels.title',
                         'upload_date',
                         'view_count',
                         'query',
                         'sort',
                         'direction')
  end

  def format_value(value)
    value ||= 'N/A'
  end
end
